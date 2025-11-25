//
//  CollectionViewModel.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CollectionViewModel: ObservableObject {
    @Published var userCards: [(card: Card, count: Int)] = []
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    var totalCards: Int {
        userCards.reduce(0) { $0 + $1.count }
    }
    
    var uniqueCards: Int {
        userCards.count
    }
    
    func fetchUserCollection() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No user logged in")
            return
        }
        
        isLoading = true
        
        // Fetch user's card IDs from userCollection
        db.collection("userCollection")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching user collection:", error)
                    self.isLoading = false
                    return
                }
                
                // Get all card IDs and count duplicates
                let cardIds = snapshot?.documents.compactMap { doc -> String? in
                    doc.data()["cardId"] as? String
                } ?? []
                
                // Count occurrences of each card ID
                var cardCounts: [String: Int] = [:]
                for cardId in cardIds {
                    cardCounts[cardId, default: 0] += 1
                }
                
                // Fetch actual card data
                self.fetchCardDetails(cardCounts: cardCounts)
            }
    }
    
    func fetchFriendCollection(userId: String) {
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("userCollection")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching friend collection: \(error)")
                    self.isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.isLoading = false
                    return
                }
                
                let cardIds = documents.compactMap { $0.data()["cardId"] as? String }
                self.fetchCardDetails(cardCounts: Dictionary(cardIds.map { ($0, 1) }, uniquingKeysWith: +))
            }
    }
    
    private func fetchCardDetails(cardCounts: [String: Int]) {
        let uniqueCardIds = Array(cardCounts.keys)
        
        guard !uniqueCardIds.isEmpty else {
            self.userCards = []
            self.isLoading = false
            return
        }
        
        // Fetch all cards from the card collection
        db.collection("Cards").whereField(FieldPath.documentID(), in: Array(uniqueCardIds))
            .getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching card details:", error)
                self.isLoading = false
                return
            }
            
            // Parse all cards
            let allCards = snapshot?.documents.compactMap { doc -> Card? in
                try? doc.data(as: Card.self)
            } ?? []
            
            // Filter cards that user owns and add counts
            var result: [(card: Card, count: Int)] = []
            for card in allCards {
                
                guard let cardId = card.id else {
                    print("Missing cardId")
                    return
                }
                
                if let count = cardCounts[cardId] {
                    result.append((card: card, count: count))
                }
            }
            
            // Sort by rarity (legendary first) then by name
            self.userCards = result.sorted { first, second in
                if first.card.cardRarity.rawValue != second.card.cardRarity.rawValue {
                    return first.card.cardRarity.rawValue > second.card.cardRarity.rawValue
                }
                return first.card.cardName < second.card.cardName
            }
            
            self.isLoading = false
        }
    }
}
