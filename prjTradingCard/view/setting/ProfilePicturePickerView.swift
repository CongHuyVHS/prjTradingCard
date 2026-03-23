//
//  ProfilePicturePickerView.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-24.
//

import SwiftUI

struct ProfilePicturePickerView: View {
    @Binding var selectedPfp: String
    @Binding var isPresented: Bool
    @EnvironmentObject var authManager: AuthManager
    @State private var isSaving = false
    @State private var showSuccessMessage = false
    
    
    let availablePfps = [
        "tcgpfp",
        "login",
        "signup",
        "charizard",
        "psyduck",
        "slowpoke",
        "dragonite",
        "celebi",
        "drowzee",
        "geodude",
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
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
                    // Header
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("Choose Profile Picture")
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                        
                        Button("Save") {
                            savePfp()
                        }
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                        .disabled(isSaving)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(availablePfps, id: \.self) { pfpName in
                                ProfilePictureOption(
                                    imageName: pfpName,
                                    isSelected: selectedPfp == pfpName
                                ) {
                                    selectedPfp = pfpName
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Loading overlay
                if isSaving {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text("Saving...")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.8))
                    )
                }
                
                // Success message
                if showSuccessMessage {
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 24))
                            
                            Text("Profile picture updated!")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.8))
                        )
                        .padding(.bottom, 50)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
    
    private func savePfp() {
        isSaving = true
        
        authManager.updateProfilePfp(selectedPfp) { error in
            isSaving = false
            
            if let error = error {
                print("Error updating pfp: \(error.localizedDescription)")
            } else {
                // Show success message
                withAnimation {
                    showSuccessMessage = true
                }
                
                // Hide success message and close sheet after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showSuccessMessage = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ProfilePictureOption: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // background circle with gradient
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.red, Color.orange, Color.purple]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                
                // image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                
                // Selection indicator
                if isSelected {
                    Circle()
                        .stroke(Color.blue, lineWidth: 4)
                        .frame(width: 95, height: 95)
                    
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        Spacer()
                    }
                    .frame(width: 90, height: 90)
                } else {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 90, height: 90)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfilePicturePickerView(
        selectedPfp: .constant("tcgpfp"),
        isPresented: .constant(true)
    )
    .environmentObject(AuthManager())
}
