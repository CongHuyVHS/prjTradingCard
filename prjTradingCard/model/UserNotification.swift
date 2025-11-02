//
//  UserNotification.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation

struct UserNotification: Identifiable{
    let id =  UUID()
    let userId : Int
    let cardId: Int
    let message: String
    let isRead = false
    
}
