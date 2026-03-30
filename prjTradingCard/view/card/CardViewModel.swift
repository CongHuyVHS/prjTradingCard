//
//  CardViewModel.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CardViewModel: ObservableObject {
    @Published var allCards: [Card] = []
    private let db = Firestore.firestore()

    func fetchCards() {
        db.collection("Cards").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching cards:", error)
                return
            }

            self.allCards = snapshot?.documents.compactMap { doc in
                do {
                    return try doc.data(as: Card.self)
                } catch {
                    print("Decoding error in doc \(doc.documentID): \(error)")
                    return nil
                }
            } ?? []

            if self.allCards.isEmpty {
                print("Error: No cards were loaded from Firestore.")
            } else {
                print("Successfully loaded \(self.allCards.count) cards.")
            }
        }
    }
    
    func pullRandomCard() -> Card? {
        guard !allCards.isEmpty else {
            print("Error: No cards available.")
            return nil
        }
        
        let rarityRoll = Int.random(in: 1...100)

        let selectedRarity: CardRarity
        if rarityRoll <= 70 {
            selectedRarity = .common
        } else if rarityRoll <= 95 {
            selectedRarity = .rare
        } else {
            selectedRarity = .legendary
        }

        let filtered = allCards.filter { $0.cardRarity == selectedRarity }

        if let random = filtered.randomElement() {
            return random
        } else {
            print("Warning: No cards with rarity \(selectedRarity). Returning ANY card.")
            return allCards.randomElement()
        }
    }
    
    func saveCardToUserCollection(card: Card, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No user logged in")
            completion(false)
            return
        }

        
        
        guard let cardId = card.id else {
            print("Missing cardId")
            return
        }

        let userCardData: [String: Any] = [
            "userId": userId,
            "cardId": cardId
        ]
        
        db.collection("userCollection").addDocument(data: userCardData) { error in
            if let error = error {
                print("Error saving card to user collection:", error)
                completion(false)
            } else {
                print("Card successfully saved to user collection")
                completion(true)
            }
        }
    }
}
