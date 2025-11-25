//
//  UserCollection.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-22.
//

import SwiftUI

struct UserCollectionView: View {
    @StateObject private var viewModel = CollectionViewModel()
       @State private var selectedFilter: CardType? = nil
       
       var filteredCards: [(card: Card, count: Int)] {
           if let filter = selectedFilter {
               return viewModel.userCards.filter { $0.card.cardType == filter }
           }
           return viewModel.userCards
       }
       
       var body: some View {
           NavigationView {
               ZStack {
                   // Background
                   LinearGradient(
                       gradient: Gradient(colors: [
                           Color(red: 0.15, green: 0.2, blue: 0.35),
                           Color(red: 0.25, green: 0.3, blue: 0.45)
                       ]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   )
                   .ignoresSafeArea()
                   
                   VStack(spacing: 0) {
                       // Header Stats
                       HStack(spacing: 30) {
                           VStack(spacing: 4) {
                               Text("\(viewModel.totalCards)")
                                   .font(.system(size: 28, weight: .bold))
                                   .foregroundColor(.white)
                               Text("Total Cards")
                                   .font(.system(size: 12, weight: .medium))
                                   .foregroundColor(.white.opacity(0.7))
                           }
                           
                           VStack(spacing: 4) {
                               Text("\(viewModel.uniqueCards)")
                                   .font(.system(size: 28, weight: .bold))
                                   .foregroundColor(.white)
                               Text("Unique Cards")
                                   .font(.system(size: 12, weight: .medium))
                                   .foregroundColor(.white.opacity(0.7))
                           }
                       }
                       .padding(.vertical, 20)
                       .padding(.top, 10)
                       
                       // Type Filter
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: 12) {
                               // All Filter
                               TypeFilterPill(
                                   title: "All",
                                   isSelected: selectedFilter == nil,
                                   color: .white
                               ) {
                                   withAnimation {
                                       selectedFilter = nil
                                   }
                               }
                               
                               // Type Filters
                               ForEach([CardType.fire, .water, .grass, .electric, .psychic, .rock, .dragon, .normal], id: \.self) { type in
                                   TypeFilterPill(
                                       title: type.rawValue.capitalized,
                                       isSelected: selectedFilter == type,
                                       color: typeColors[type] ?? .gray
                                   ) {
                                       withAnimation {
                                           selectedFilter = type
                                       }
                                   }
                               }
                           }
                           .padding(.horizontal)
                       }
                       .padding(.bottom, 16)
                       
                       // Cards Grid
                       if viewModel.isLoading {
                           Spacer()
                           ProgressView()
                               .progressViewStyle(CircularProgressViewStyle(tint: .white))
                               .scaleEffect(1.5)
                           Spacer()
                       } else if filteredCards.isEmpty {
                           Spacer()
                           VStack(spacing: 12) {
                               Image(systemName: "tray")
                                   .font(.system(size: 60))
                                   .foregroundColor(.white.opacity(0.5))
                               Text(selectedFilter == nil ? "No cards yet" : "No \(selectedFilter!.rawValue) cards")
                                   .font(.system(size: 18, weight: .medium))
                                   .foregroundColor(.white.opacity(0.7))
                               Text("Open packs to start your collection!")
                                   .font(.system(size: 14))
                                   .foregroundColor(.white.opacity(0.5))
                           }
                           Spacer()
                       } else {
                           ScrollView {
                               LazyVGrid(columns: [
                                   GridItem(.flexible()),
                                   GridItem(.flexible())
                               ], spacing: 20) {
                                   ForEach(filteredCards, id: \.card.id) { item in
                                       CardRowView(card: item.card, count: item.count)
                                   }
                               }
                               .padding()
                           }
                       }
                   }
               }
               .navigationTitle("My Collection")
               .navigationBarTitleDisplayMode(.inline)
               .toolbarColorScheme(.dark, for: .navigationBar)
               .toolbarBackground(.visible, for: .navigationBar)
               .toolbarBackground(
                   Color(red: 0.15, green: 0.2, blue: 0.35),
                   for: .navigationBar
               )
           }
           .onAppear {
               viewModel.fetchUserCollection()
           }
       }
   }

   struct TypeFilterPill: View {
       let title: String
       let isSelected: Bool
       let color: Color
       let action: () -> Void
       
       var body: some View {
           Button(action: action) {
               Text(title)
                   .font(.system(size: 14, weight: .semibold))
                   .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                   .padding(.horizontal, 16)
                   .padding(.vertical, 8)
                   .background(
                       RoundedRectangle(cornerRadius: 20)
                           .fill(isSelected ? color : Color.white.opacity(0.1))
                   )
                   .overlay(
                       RoundedRectangle(cornerRadius: 20)
                           .stroke(color, lineWidth: isSelected ? 2 : 1)
                   )
           }
       }
   }

   struct CardDetailSheet: View {
       @Environment(\.dismiss) var dismiss
       let card: Card
       let count: Int
       
       var body: some View {
           ZStack {
               Color.black.opacity(0.9)
                   .ignoresSafeArea()
               
               VStack(spacing: 20) {
                   HStack {
                       Spacer()
                       Button(action: { dismiss() }) {
                           Image(systemName: "xmark.circle.fill")
                               .font(.system(size: 30))
                               .foregroundColor(.white.opacity(0.7))
                       }
                   }
                   .padding()
                   
                   Spacer()
                   
                   CardView(currentCard: card)
                       .scaleEffect(1.1)
                   
                   VStack(spacing: 8) {
                       HStack(spacing: 12) {
                           // Type Badge
                           HStack(spacing: 6) {
                               Circle()
                                   .fill(typeColors[card.cardType] ?? .white)
                                   .frame(width: 12, height: 12)
                               Text(card.cardType.rawValue.capitalized)
                                   .font(.system(size: 14, weight: .semibold))
                                   .foregroundColor(.white)
                           }
                           .padding(.horizontal, 12)
                           .padding(.vertical, 6)
                           .background(
                               RoundedRectangle(cornerRadius: 12)
                                   .fill(Color.white.opacity(0.1))
                           )
                           
                           // Rarity Badge
                           Text(rarityName(card.cardRarity))
                               .font(.system(size: 14, weight: .semibold))
                               .foregroundColor(.white)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 6)
                               .background(
                                   RoundedRectangle(cornerRadius: 12)
                                       .fill((rarityColors[card.cardRarity] ?? .white).opacity(0.3))
                               )
                               .overlay(
                                   RoundedRectangle(cornerRadius: 12)
                                       .stroke(rarityColors[card.cardRarity] ?? .white, lineWidth: 1)
                               )
                       }
                       
                       // Count Badge
                       if count > 1 {
                           Text("Owned: ×\(count)")
                               .font(.system(size: 16, weight: .bold))
                               .foregroundColor(.white)
                               .padding(.horizontal, 16)
                               .padding(.vertical, 8)
                               .background(
                                   RoundedRectangle(cornerRadius: 12)
                                       .fill(Color.white.opacity(0.15))
                               )
                       }
                   }
                   .padding(.top, 10)
                   
                   Spacer()
               }
           }
       }
       
       func rarityName(_ rarity: CardRarity) -> String {
           switch rarity {
           case .common: return "Common"
           case .rare: return "Rare"
           case .legendary: return "Legendary"
           }
       }
}

struct UserCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        UserCollectionView()
    }
}

