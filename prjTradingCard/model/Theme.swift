//
//  Theme.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-21.
//

import Foundation
import SwiftUI

enum CardType: String, Codable {
    case fire, water, grass, electric, psychic, rock, dragon, normal
}

enum CardRarity: Int, Codable { // card rarity -> int so its easier for the rarity color 
    case common = 0
    case rare = 1
    case legendary = 2
}

let typeColors: [CardType: Color] = [
    .fire: .red,
    .water: .blue,
    .grass: .green,
    .electric: .yellow,
    .psychic: .purple,
    .rock: .brown,
    .dragon: .orange,
    .normal: .gray
]

let rarityColors: [CardRarity: Color] = [
    .common: .gray,
    .rare: .blue,
    .legendary: .orange
]
