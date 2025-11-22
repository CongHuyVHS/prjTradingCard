//
//  Users.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var email: String
    var username: String
    var pfp: String
    var password: String
}
