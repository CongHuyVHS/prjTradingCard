//
//  Cards.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation

enum rarity {
case Common,Rare,Legendary
}

struct Card: Identifiable{
    let id = UUID()
    let cardName: String
    let cardRarity: rarity
    let cardImage: String 
}
