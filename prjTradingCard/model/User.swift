//
//  Users.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation

struct User: Identifiable{
    let id = UUID()
    let username: String
    let password: String
}
