//
//  Cards.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import Foundation
import FirebaseFirestore


struct Card: Identifiable, Codable{
    @DocumentID var id: String?
    var cardName: String
    var cardRarity: CardRarity
    var cardType: CardType
    var cardImage: String
    var cardDescription: String
}

var card_data = Card(cardName:"GrassMuncher",cardRarity:CardRarity.common, cardType:CardType.grass, cardImage:"tcgpfp", cardDescription: "Stinky ahhh pokemon u feel me twin?")
