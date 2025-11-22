//
//  UserCollection.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation
import FirebaseFirestore

struct UserCollection: Codable{
    @DocumentID var userId: String?
    @DocumentID var cardId: String?
    
}
