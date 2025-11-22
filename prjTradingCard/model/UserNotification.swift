//
//  UserNotification.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation
import FirebaseFirestore

struct UserNotification: Identifiable, Codable{
    @DocumentID var id: String?
    @DocumentID var userId: String?
    @DocumentID var cardId: String?
    var message: String
    var isRead = false
    
}
