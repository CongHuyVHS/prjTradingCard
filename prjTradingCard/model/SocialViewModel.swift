//
//  SocialViewModel.swift
//  prjTradingCard
//
//  Created by Bu on 22/11/25.
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
    @Published var selectedFilter: FriendFilter = .all
    
    private let db = Firestore.firestore()
    
    enum FriendFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case sent = "Sent"
        case favorites = "Favorites"
    }
    
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        
        // load friends from firestore
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
        
        // apply category filter
        switch selectedFilter {
        case .all:
            filtered = friends.filter { $0.friendshipStatus == .accepted }
        case .pending:
            filtered = friends.filter { $0.friendshipStatus == .pending }
        case .sent:
            filtered = friends.filter { $0.friendshipStatus == .sent }
        case .favorites:
            filtered = friends.filter { $0.friendshipStatus == .accepted && $0.isFavorite }
        }
        
        // apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
        
        filteredFriends = filtered
    }
    
    func getCount(for filter: FriendFilter) -> Int {
        switch filter {
        case .all:
            return friends.filter { $0.friendshipStatus == .accepted }.count
        case .pending:
            return friends.filter { $0.friendshipStatus == .pending }.count
        case .sent:
            return friends.filter { $0.friendshipStatus == .sent }.count
        case .favorites:
            return friends.filter { $0.friendshipStatus == .accepted && $0.isFavorite }.count
        }
    }
    
    func toggleFavorite(for friend: Friend) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let friendId = friend.id else { return }
        
        if let index = friends.firstIndex(where: { $0.id == friendId }) {
            friends[index].isFavorite.toggle()
            let newFavoriteStatus = friends[index].isFavorite
            
            // update in firestore
            db.collection("users").document(currentUserId)
                .collection("friends").document(friendId)
                .updateData(["isFavorite": newFavoriteStatus]) { error in
                    if let error = error {
                        print("Error updating favorite status: \(error.localizedDescription)")
                    }
                }
            
            filterFriends()
        }
    }
    
    // perform an asynchronous operation to accept a friend request (from a Friend object)
    func acceptFriendRequest(friend: Friend, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let friendId = friend.id else {
            completion(false, "Invalid user data")
            return
        }
        
        // update friendship status to accepted
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId)
            .updateData([
                "friendshipStatus": FriendshipStatus.accepted.rawValue,
                "dateAdded": Date()
            ]) { [weak self] error in
                if let error = error {
                    completion(false, "Error accepting friend request: \(error.localizedDescription)")
                    return
                }
                
                // Also update the other user's friendship status from "sent" to "accepted"
                self?.db.collection("users").document(friendId)
                    .collection("friends").document(currentUserId)
                    .updateData([
                        "friendshipStatus": FriendshipStatus.accepted.rawValue,
                        "dateAdded": Date()
                    ])
                
                completion(true, "Friend request accepted!")
            }
    }
    
    // perform an asynchronous operation to decline a friend request (remove it from both users' friend lists)
    func declineFriendRequest(friend: Friend, completion: @escaping (Bool, String) -> Void) {
        guard let _ = Auth.auth().currentUser?.uid,
              let friendId = friend.id else {
            completion(false, "Invalid user data")
            return
        }
        
        removeFriend(friendId: friendId, completion: completion)
    }
    
    func addFriend(username: String, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        guard !username.isEmpty else {
            completion(false, "Please enter a username")
            return
        }
        
        isLoading = true
        
        // find user by username
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                completion(false, "Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false, "No user found with username '\(username)'")
                return
            }
            
            let userDoc = documents[0]
            guard let friendData = try? userDoc.data(as: User.self),
                  let friendId = friendData.id else {
                completion(false, "Invalid user data")
                return
            }
            
            // check if trying to add yourself
            if friendId == currentUserId {
                completion(false, "You cannot add yourself as a friend")
                return
            }
            
            // check if already friends or request exists
            if self.friends.contains(where: { $0.id == friendId }) {
                completion(false, "Friend request already exists or already friends")
                return
            }
            
            // get current user data
            self.db.collection("users").document(currentUserId).getDocument { currentUserDoc, error in
                guard let currentUserData = try? currentUserDoc?.data(as: User.self) else {
                    completion(false, "Could not load your user data")
                    return
                }
                
                // create friend request for current user (status: sent)
                let sentRequest = Friend(
                    id: friendId,
                    username: friendData.username,
                    pfp: friendData.pfp,
                    email: friendData.email,
                    status: "Offline",
                    friendshipStatus: .sent,
                    isFavorite: false
                )
                
                // create friend request for target user (status: pending)
                let pendingRequest = Friend(
                    id: currentUserId,
                    username: currentUserData.username,
                    pfp: currentUserData.pfp,
                    email: currentUserData.email,
                    status: "Offline",
                    friendshipStatus: .pending,
                    isFavorite: false
                )
                
                do {
                    // add to current user's friends (sent status)
                    try self.db.collection("users").document(currentUserId)
                        .collection("friends").document(friendId).setData(from: sentRequest)
                    
                    // add to target user's friends (pending status)
                    try self.db.collection("users").document(friendId)
                        .collection("friends").document(currentUserId).setData(from: pendingRequest)
                    
                    completion(true, "Friend request sent to \(friendData.username)!")
                } catch {
                    completion(false, "Error sending friend request: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeFriend(friendId: String, completion: @escaping (Bool, String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        // remove from current user's friends
        db.collection("users").document(currentUserId)
            .collection("friends").document(friendId).delete { error in
                if let error = error {
                    completion(false, "Error removing friend: \(error.localizedDescription)")
                } else {
                    // remove from friend's friends list
                    self.db.collection("users").document(friendId)
                        .collection("friends").document(currentUserId).delete()
                    
                    completion(true, "Friend removed successfully")
                }
            }
    }
}
