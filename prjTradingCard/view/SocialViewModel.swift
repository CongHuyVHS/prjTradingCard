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
    enum FriendFilter: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
        case pending = "Pending"
        case sent = "Sent"
    }
    
    @Published var friends: [Friend] = []
    @Published var filteredFriends: [Friend] = []
    @Published var searchText: String = ""
    @Published var selectedFilter: FriendFilter = .all
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
        var filtered = friends
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { friend in
                friend.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Additional filtering based on selected filter
        switch selectedFilter {
        case .all:
            break // No additional filtering
        case .favorites:
            filtered = filtered.filter { $0.isFavorite }
        case .pending:
            filtered = filtered.filter { $0.friendshipStatus == .pending }
        case .sent:
            filtered = filtered.filter { $0.friendshipStatus == .sent }
        }
        
        filteredFriends = filtered
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
    
    func getCount(for filter: FriendFilter) -> Int {
        switch filter {
        case .all:
            return friends.count
        case .favorites:
            return friends.filter { $0.isFavorite }.count
        case .pending:
            return friends.filter { $0.friendshipStatus == .pending }.count
        case .sent:
            return friends.filter { $0.friendshipStatus == .sent }.count
        }
    }
    
    func acceptFriendRequest(friend: Friend, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let friendId = friend.id else {
            completion(false, "Invalid user data")
            return
        }
        
        // Update friend status to accepted
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId)
            .updateData(["friendshipStatus": FriendshipStatus.accepted.rawValue]) { error in
                if let error = error {
                    completion(false, "Error accepting friend request: \(error.localizedDescription)")
                } else {
                    // Also update the other user's friend status
                    self.db.collection("users").document(friendId)
                        .collection("friends").document(currentUserId)
                        .updateData(["friendshipStatus": FriendshipStatus.accepted.rawValue])
                    
                    completion(true, "Friend request accepted!")
                }
            }
    }
    
    func declineFriendRequest(friend: Friend, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let friendId = friend.id else {
            completion(false, "Invalid user data")
            return
        }
        
        // Remove friend request
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId).delete { error in
                if let error = error {
                    completion(false, "Error declining friend request: \(error.localizedDescription)")
                } else {
                    // Also remove from the other user's friends list
                    self.db.collection("users").document(friendId)
                        .collection("friends").document(currentUserId).delete()
                    
                    completion(true, "Friend request declined")
                }
            }
    }
    
    func toggleFavorite(for friend: Friend) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let friendId = friend.id else {
            return
        }
        
        let newFavoriteStatus = !friend.isFavorite
        
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId)
            .updateData(["isFavorite": newFavoriteStatus]) { error in
                if let error = error {
                    print("Error toggling favorite: \(error.localizedDescription)")
                }
            }
    }
    
    func addFriend(username: String, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        isLoading = true
        
        // Find user by username
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                completion(false, "Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false, "No user found with that username")
                return
            }
            
            let userDoc = documents[0]
            guard let friendData = try? userDoc.data(as: User.self),
                  let friendId = friendData.id else {
                completion(false, "Invalid user data")
                return
            }
            
            // Check if it's the current user
            if friendId == currentUserId {
                completion(false, "You cannot add yourself as a friend")
                return
            }
            
            // Check if already friends or request already sent
            if self.friends.contains(where: { $0.id == friendId }) {
                completion(false, "Already friends or request pending")
                return
            }
            
            // Send friend request (add to current user's friends with "sent" status)
            let friendRequest = Friend(
                id: friendId,
                username: friendData.username,
                pfp: friendData.pfp,
                email: friendData.email,
                status: "Offline",
                dateAdded: Date(),
                friendshipStatus: .sent,
                isFavorite: false
            )
            
            do {
                try self.db.collection("users").document(currentUserId)
                    .collection("friends").document(friendId).setData(from: friendRequest)
                
                // Add to friend's friends collection with "pending" status
                let pendingRequest = Friend(
                    id: currentUserId,
                    username: Auth.auth().currentUser?.displayName ?? "Unknown",
                    pfp: "",
                    email: Auth.auth().currentUser?.email ?? "",
                    status: "Offline",
                    dateAdded: Date(),
                    friendshipStatus: .pending,
                    isFavorite: false
                )
                
                try self.db.collection("users").document(friendId)
                    .collection("friends").document(currentUserId).setData(from: pendingRequest)
                
                completion(true, "Friend request sent successfully!")
            } catch {
                completion(false, "Error sending friend request: \(error.localizedDescription)")
            }
        }
    }
}
