//
//  AddFriendView.swift
//  prjTradingCard
//
//  Created by Bu on 22/11/25.
//

import SwiftUI

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SocialViewModel
    
    @State private var friendUsername: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
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
                
                VStack(spacing: 30) {
                    // icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.badge.plus.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 10) {
                        Text("Add New Friend")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Enter your friend's username")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    // username input field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            
                            TextField("ex: grassmuncher", text: $friendUsername)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    // add friend button
                    Button(action: {
                        addFriend()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 18))
                                Text("Add Friend")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: friendUsername.isEmpty ? [Color.gray] : [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: friendUsername.isEmpty ? Color.clear : Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(friendUsername.isEmpty || viewModel.isLoading)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(isSuccess ? "Success" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if isSuccess {
                            dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func addFriend() {
        guard !friendUsername.isEmpty else { return }
        
        viewModel.addFriend(username: friendUsername) { success, message in
            isSuccess = success
            alertMessage = message
            showAlert = true
            
            if success {
                friendUsername = ""
            }
        }
    }
}

#Preview {
    AddFriendView(viewModel: SocialViewModel())
}
