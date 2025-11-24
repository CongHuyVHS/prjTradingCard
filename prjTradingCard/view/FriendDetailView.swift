//
//  FriendDetailView.swift
//  prjTradingCard
//
//  Created by Bu on 22/11/25.
//

import SwiftUI

struct FriendDetailView: View {
    @Environment(\.dismiss) var dismiss
    let friend: Friend
    @ObservedObject var viewModel: SocialViewModel
    
    @State private var showRemoveAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.85, green: 0.88, blue: 0.95),
                        Color(red: 0.78, green: 0.83, blue: 0.92)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        // profile header
                        VStack(spacing: 15) {
                            // profile picture
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 130, height: 130)
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                if !friend.pfp.isEmpty {
                                    Image(friend.pfp)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                } else {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Text(friend.username.prefix(1).uppercased())
                                                .font(.system(size: 50, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                }
                                
                                // status indicator
                                Circle()
                                    .fill(statusColor(for: friend.status ?? "Offline"))
                                    .frame(width: 24, height: 24)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .offset(x: 45, y: 45)
                            }
                            .padding(.top, 30)
                            
                            // username
                            Text(friend.username)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            // status
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(statusColor(for: friend.status ?? "Offline"))
                                    .frame(width: 8, height: 8)
                                
                                Text(friend.status ?? "Offline")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        // info cards
                        VStack(spacing: 15) {
                            InfoCard(icon: "envelope.fill", title: "Email", value: friend.email)
                            
                            if let dateAdded = friend.dateAdded {
                                InfoCard(icon: "calendar", title: "Friends Since", value: formatDate(dateAdded))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // action buttons
                        VStack(spacing: 12) {
                            // favorite button (only for accepted friends)
                            if friend.friendshipStatus == .accepted {
                                ActionButton(
                                    icon: friend.isFavorite ? "star.fill" : "star",
                                    title: friend.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                    colors: friend.isFavorite ? [Color.yellow, Color.orange] : [Color.gray, Color.gray.opacity(0.7)]
                                ) {
                                    viewModel.toggleFavorite(for: friend)
                                }
                            }
                            
                            // view Collection button
                            ActionButton(
                                icon: "square.grid.2x2.fill",
                                title: "View Collection",
                                colors: [Color.blue, Color.cyan]
                            ) {
                                // navigate to friend's collection
                                // TODO: implement collection view
                            }
                            
                            // challenge button (might implement this in the future)
                            ActionButton(
                                icon: "gamecontroller.fill",
                                title: "Challenge to Battle",
                                colors: [Color.orange, Color.red]
                            ) {
                                // start a battle challenge/trade card
                                // TODO: implement battle system
                            }
                            
                            // remove friend button
                            ActionButton(
                                icon: "person.fill.xmark",
                                title: "Remove Friend",
                                colors: [Color.red, Color.red.opacity(0.7)]
                            ) {
                                showRemoveAlert = true
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Remove Friend", isPresented: $showRemoveAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Remove", role: .destructive) {
                    removeFriend()
                }
            } message: {
                Text("Are you sure you want to remove \(friend.username) from your friends?")
            }
            .alert("Result", isPresented: $showResultAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(resultMessage)
            }
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "online":
            return .green
        case "playing":
            return .blue
        default:
            return .gray
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func removeFriend() {
        guard let friendId = friend.id else { return }
        
        viewModel.removeFriend(friendId: friendId) { success, message in
            resultMessage = message
            showResultAlert = true
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let colors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: colors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: colors[0].opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    FriendDetailView(
        friend: Friend(
            id: "1",
            username: "TestUser",
            pfp: "tcgpfp",
            email: "test@example.com",
            status: "Online",
            dateAdded: Date()
        ),
        viewModel: SocialViewModel()
    )
}
