//
//  FriendCollectionView.swift
//  prjTradingCard
//
//  Created by Bu on 24/11/25.
//

import SwiftUI

struct FriendCollectionView: View {
    let friend: Friend
    @StateObject private var viewModel = CollectionViewModel()
    @State private var selectedFilter: CardType? = nil
    @Environment(\.dismiss) var dismiss
    
    var filteredCards: [(card: Card, count: Int)] {
        if let filter = selectedFilter {
            return viewModel.userCards.filter { $0.card.cardType == filter }
        }
        return viewModel.userCards
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    // header with friend info
                    HStack(spacing: 15) {
                        if !friend.pfp.isEmpty {
                            Image(friend.pfp)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text(friend.username.prefix(1).uppercased())
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(friend.username)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            Text("Collection")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    
                    // stats of friend
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
                    
                    // type filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            TypeFilterPill(
                                title: "All",
                                isSelected: selectedFilter == nil,
                                color: .white
                            ) {
                                withAnimation {
                                    selectedFilter = nil
                                }
                            }
                            
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
                    
                    // cards Grid
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
                            Text("No cards yet")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            if let friendId = friend.id {
                viewModel.fetchFriendCollection(userId: friendId)
            }
        }
    }
}

struct FriendCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        FriendCollectionView(friend: Friend(
            id: "friend123",
            username: "grassmuncher",
            pfp: "",
            email: "friend@example.com",
            status: "online",
            dateAdded: Date(),
            friendshipStatus: .accepted,
            isFavorite: false
        ))
    }
}
