
//
//  FriendView.swift
//  prjTradingCard
//
//  Created by Bu on 22/11/25.
//

import SwiftUI

struct FriendView: View {
    @EnvironmentObject var viewModel: SocialViewModel
     @State private var showAddFriend = false
     @State private var selectedFriend: Friend?
     @State private var showFriendDetail = false
     
     var body: some View {
         ZStack {
             // background gradient
             LinearGradient(
                 gradient: Gradient(colors: [
                     Color(red: 0.85, green: 0.88, blue: 0.95),
                     Color(red: 0.78, green: 0.83, blue: 0.92)
                 ]),
                 startPoint: .topLeading,
                 endPoint: .bottomTrailing
             )
             .ignoresSafeArea()
             
             VStack(spacing: 0) {
                 // header with search and add button
                 HStack(spacing: 12) {
                     // search bar
                     HStack {
                         Image(systemName: "magnifyingglass")
                             .foregroundColor(.gray)
                             .font(.system(size: 16))
                         
                         TextField("Search friends...", text: $viewModel.searchText)
                             .onChange(of: viewModel.searchText) { _ in
                                 viewModel.filterFriends()
                             }
                     }
                     .padding(.horizontal, 15)
                     .padding(.vertical, 12)
                     .background(
                         RoundedRectangle(cornerRadius: 15)
                             .fill(Color.white.opacity(0.9))
                             .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                     )
                     
                     // add friend button on top
                     Button(action: {
                         showAddFriend = true
                     }) {
                         ZStack {
                             Circle()
                                 .fill(
                                     LinearGradient(
                                         gradient: Gradient(colors: [Color.blue, Color.purple]),
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing
                                     )
                                 )
                                 .frame(width: 48, height: 48)
                                 .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                             
                             Image(systemName: "person.badge.plus.fill")
                                 .foregroundColor(.white)
                                 .font(.system(size: 20))
                         }
                     }
                 }
                 .padding(.horizontal, 16)
                 .padding(.top, 20)
                 .padding(.bottom, 15)
                 
                 // filter tabs
                 ScrollView(.horizontal, showsIndicators: false) {
                     HStack(spacing: 10) {
                         ForEach(SocialViewModel.FriendFilter.allCases, id: \.self) { filter in
                             FilterButton(
                                 title: filter.rawValue,
                                 isSelected: viewModel.selectedFilter == filter,
                                 count: viewModel.getCount(for: filter)
                             ) {
                                 viewModel.selectedFilter = filter
                                 viewModel.filterFriends()
                             }
                         }
                     }
                     .padding(.horizontal, 16)
                 }
                 .padding(.bottom, 15)
                 
                 // friends list
                 if viewModel.isLoading {
                     Spacer()
                     ProgressView()
                         .scaleEffect(1.5)
                     Spacer()
                 } else if viewModel.filteredFriends.isEmpty {
                     Spacer()
                     VStack(spacing: 15) {
                         Image(systemName: "person.2.slash.fill")
                             .font(.system(size: 60))
                             .foregroundColor(.gray.opacity(0.5))
                         
                         Text(viewModel.searchText.isEmpty ? "No friends yet" : "No friends found")
                             .font(.system(size: 18, weight: .medium))
                             .foregroundColor(.gray)
                         
                         if viewModel.searchText.isEmpty {
                             Text("Add friends to see them here!")
                                 .font(.system(size: 14))
                                 .foregroundColor(.gray.opacity(0.8))
                         }
                     }
                     Spacer()
                 } else {
                     ScrollView(showsIndicators: false) {
                         LazyVStack(spacing: 12) {
                             ForEach(viewModel.filteredFriends) { friend in
                                 FriendRowView(friend: friend, viewModel: viewModel)
                                     .onTapGesture {
                                         // Only allow tap if not loading
                                         if !viewModel.isLoading {
                                             selectedFriend = friend
                                             showFriendDetail = true
                                         }
                                     }
                             }
                         }
                         .padding(.horizontal, 16)
                         .padding(.bottom, 20)
                     }
                 }
             }
             
             // alternative floating add friend button
             VStack {
                 Spacer()
                 HStack {
                     Spacer()
                     Button(action: {
                         showAddFriend = true
                     }) {
                         ZStack {
                             Circle()
                                 .fill(
                                     LinearGradient(
                                         gradient: Gradient(colors: [Color.blue, Color.purple]),
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing
                                     )
                                 )
                                 .frame(width: 60, height: 55)
                                 .shadow(color: Color.blue.opacity(0.4), radius: 10, x: 0, y: 5)
                             
                             Image(systemName: "plus")
                                 .foregroundColor(.white)
                                 .font(.system(size: 28, weight: .semibold))
                         }
                     }
                     .padding(.trailing, 20)
                     .padding(.bottom, 25)
                 }
             }
         }
         .sheet(isPresented: $showAddFriend) {
             AddFriendView(viewModel: viewModel)
         }
         .sheet(isPresented: $showFriendDetail) {
             if let friend = selectedFriend {
                 FriendDetailView(friend: friend, viewModel: viewModel)
             }
         }
         .navigationBarTitleDisplayMode(.inline)
         .navigationTitle("Friends")
     }
 }

 // friend row view component
 struct FriendRowView: View {
     let friend: Friend
     @ObservedObject var viewModel: SocialViewModel
     @State private var showAcceptDeclineButtons = false
     
     var body: some View {
         HStack(spacing: 15) {
             // profile picture with status indicator
             ZStack(alignment: .bottomTrailing) {
                 // profile picture
                 if !friend.pfp.isEmpty {
                     Image(friend.pfp)
                         .resizable()
                         .scaledToFill()
                         .frame(width: 60, height: 60)
                         .clipShape(Circle())
                         .overlay(Circle().stroke(Color.white, lineWidth: 3))
                         .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                 } else {
                     Circle()
                         .fill(
                             LinearGradient(
                                 gradient: Gradient(colors: [Color.blue, Color.purple]),
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing
                             )
                         )
                         .frame(width: 60, height: 60)
                         .overlay(
                             Text(friend.username.prefix(1).uppercased())
                                 .font(.system(size: 24, weight: .bold))
                                 .foregroundColor(.white)
                         )
                         .overlay(Circle().stroke(Color.white, lineWidth: 3))
                         .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                 }
                 
                 // status indicator (only for accepted friends)
                 if friend.friendshipStatus == .accepted {
                     Circle()
                         .fill(statusColor(for: friend.status ?? "Offline"))
                         .frame(width: 16, height: 16)
                         .overlay(Circle().stroke(Color.white, lineWidth: 2))
                 }
             }
             
             // friend info
             VStack(alignment: .leading, spacing: 4) {
                 Text(friend.username)
                     .font(.system(size: 17, weight: .semibold))
                     .foregroundColor(.primary)
                 
                 Text(statusText)
                     .font(.system(size: 14))
                     .foregroundColor(statusTextColor)
             }
             
             Spacer()
             
             // actions based on friendship status
             if friend.friendshipStatus == .pending {
                 // accept/decline buttons for pending requests
                 HStack(spacing: 8) {
                     Button(action: {
                         viewModel.acceptFriendRequest(friend: friend) { _, _ in }
                     }) {
                         Image(systemName: "checkmark.circle.fill")
                             .foregroundColor(.green)
                             .font(.system(size: 28))
                     }
                     
                     Button(action: {
                         viewModel.declineFriendRequest(friend: friend) { _, _ in }
                     }) {
                         Image(systemName: "xmark.circle.fill")
                             .foregroundColor(.red)
                             .font(.system(size: 28))
                     }
                 }
             } else if friend.friendshipStatus == .sent {
                 // pending indicator for sent requests
                 Text("Pending")
                     .font(.system(size: 13, weight: .medium))
                     .foregroundColor(.orange)
                     .padding(.horizontal, 10)
                     .padding(.vertical, 5)
                     .background(
                         Capsule()
                             .fill(Color.orange.opacity(0.1))
                     )
             } else if friend.friendshipStatus == .accepted {
                 // favorite star and chevron for accepted friends
                 HStack(spacing: 10) {
                     Button(action: {
                         viewModel.toggleFavorite(for: friend)
                     }) {
                         Image(systemName: friend.isFavorite ? "star.fill" : "star")
                             .foregroundColor(friend.isFavorite ? .yellow : .gray.opacity(0.5))
                             .font(.system(size: 20))
                     }
                     
                     Image(systemName: "chevron.right")
                         .foregroundColor(.gray.opacity(0.5))
                         .font(.system(size: 14, weight: .semibold))
                 }
             }
         }
         .padding(.horizontal, 16)
         .padding(.vertical, 12)
         .background(
             RoundedRectangle(cornerRadius: 16)
                 .fill(Color.white.opacity(0.9))
                 .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
         )
     }
     
     var statusText: String {
         switch friend.friendshipStatus {
         case .accepted:
             return friend.status ?? "Offline"
         case .pending:
             return "Wants to be friends"
         case .sent:
             return "Awaiting response"
         }
     }
     
     var statusTextColor: Color {
         switch friend.friendshipStatus {
         case .accepted:
             return .gray
         case .pending:
             return .blue
         case .sent:
             return .orange
         }
     }
     
     func statusColor(for status: String) -> Color {
         switch status.lowercased() {
         case "online":
             return .green
         case "playing":
             return .blue
         default:
             return .gray
         }
     }
 }

 struct FilterButton: View {
     let title: String
     let isSelected: Bool
     let count: Int
     let action: () -> Void
     
     var body: some View {
         Button(action: action) {
             HStack {
                 Text(title)
                     .font(.system(size: 16, weight: .medium))
                     .foregroundColor(isSelected ? .white : .blue)
                 
                 if count > 0 {
                     Text("\(count)")
                         .font(.system(size: 14))
                         .foregroundColor(isSelected ? .white : .blue)
                         .padding(.horizontal, 8)
                         .padding(.vertical, 4)
                         .background(
                             Capsule()
                                 .fill(isSelected ? Color.blue.opacity(0.8) : Color.blue.opacity(0.1))
                         )
                 }
             }
             .padding(.horizontal, 12)
             .padding(.vertical, 10)
             .background(
                 Capsule()
                     .fill(isSelected ? Color.blue : Color.clear)
                     .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
             )
         }
     }
 }

#Preview {
    FriendView()
        .environmentObject(SocialViewModel())
}
