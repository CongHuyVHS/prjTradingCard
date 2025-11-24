//
//  Friend.swift
//  prjTradingCard
//
//  Created by Bu on 22/11/25.
//

import Foundation
import FirebaseFirestore

enum FriendshipStatus: String, Codable {
    case accepted = "accepted" // mutual friends
    case pending = "pending" // incoming friend request
    case sent = "sent" // outgoing friend request
}

struct Friend: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var pfp: String
    var email: String
    var status: String? // ex: online, offline, playing
    var dateAdded: Date?
    var friendshipStatus: FriendshipStatus
    var isFavorite: Bool
    
    init(id: String? = nil, username: String, pfp: String, email: String, status: String? = nil, dateAdded: Date? = nil, friendshipStatus: FriendshipStatus = .accepted, isFavorite: Bool = false) {
        self.id = id
        self.username = username
        self.pfp = pfp
        self.email = email
        self.status = status
        self.dateAdded = dateAdded
        self.friendshipStatus = friendshipStatus
        self.isFavorite = isFavorite
    }
}
