//
//  CardRowView.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-22.
//

import SwiftUI

struct CardRowView: View {
    let card: Card
    let count: Int
    @State private var showCardDetail = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            CardView(currentCard: card)
                .scaleEffect(0.62)
                .frame(width: 160, height: 235)
                .clipped()
            
            // Count Badge
            if count > 1 {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.8))
                        .frame(width: 36, height: 36)
                    
                    Circle()
                        .stroke(rarityColors[card.cardRarity] ?? .white, lineWidth: 2)
                        .frame(width: 36, height: 36)
                    
                    Text("×\(count)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: -8, y: -8)
            }
        }
        .onTapGesture {
            showCardDetail = true
        }
        .sheet(isPresented: $showCardDetail) {
            CardDetailSheet(card: card, count: count)
        }
    }
}

struct CardRowView_Previews: PreviewProvider {
    static var previews: some View {
        CardRowView(card: card_data, count: 3)
            .padding()
    }
}
