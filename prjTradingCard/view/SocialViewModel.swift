//
//  SocialViewModel.swift
//  prjTradingCard
//
//  Created by Zim on 11/22/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SocialViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    @Published var filteredFriends: [Friend] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        
        // Load friends from Firestore
        db.collection("users").document(userId).collection("friends")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error loading friends: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.friends = []
                    self.filteredFriends = []
                    return
                }
                
                self.friends = documents.compactMap { doc -> Friend? in
                    try? doc.data(as: Friend.self)
                }
                
                self.filterFriends()
            }
    }
    
    func filterFriends() {
        if searchText.isEmpty {
            filteredFriends = friends
        } else {
            filteredFriends = friends.filter { friend in
                friend.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func addFriend(email: String, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        isLoading = true
        
        // Find user by email
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                completion(false, "Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false, "No user found with that email")
                return
            }
            
            let userDoc = documents[0]
            guard let friendData = try? userDoc.data(as: User.self),
                  let friendId = friendData.id else {
                completion(false, "Invalid user data")
                return
            }
            
            // Check if already friends
            if self.friends.contains(where: { $0.id == friendId }) {
                completion(false, "Already friends with this user")
                return
            }
            
            // Add friend to current user's friends collection
            let friend = Friend(
                id: friendId,
                username: friendData.username,
                pfp: friendData.pfp,
                email: friendData.email,
                status: "Offline",
                dateAdded: Date()
            )
            
            do {
                try self.db.collection("users").document(currentUserId)
                    .collection("friends").document(friendId).setData(from: friend)
                
                // Also add current user to friend's friends collection (mutual friendship)
                self.db.collection("users").document(friendId)
                    .collection("friends").document(currentUserId).getDocument { doc, error in
                        if let currentUser = try? doc?.data(as: User.self) {
                            let mutualFriend = Friend(
                                id: currentUserId,
                                username: currentUser.username,
                                pfp: currentUser.pfp,
                                email: currentUser.email,
                                status: "Offline",
                                dateAdded: Date()
                            )
                            try? self.db.collection("users").document(friendId)
                                .collection("friends").document(currentUserId).setData(from: mutualFriend)
                        }
                    }
                
                completion(true, "Friend added successfully!")
            } catch {
                completion(false, "Error adding friend: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFriend(friendId: String, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        // Remove from current user's friends
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId).delete { error in
                if let error = error {
                    completion(false, "Error removing friend: \(error.localizedDescription)")
                } else {
                    // Also remove from friend's friends list
                    self.db.collection("users").document(friendId)
                        .collection("friends").document(currentUserId).delete()
                    
                    completion(true, "Friend removed successfully")
                }
            }
    }
}
