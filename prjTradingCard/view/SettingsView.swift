//
//  SettingsView.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-20.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
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
                // Custom Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer for centering
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Profile Picture Section
                        VStack(spacing: 16) {
                            Text("Profile Picture")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 20) {
                                    // Profile Picture Display
                                    ZStack {
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
                                        
                                        Image("tcgpfp")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 95, height: 95)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        
                                        // Camera icon overlay
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue)
                                                        .frame(width: 32, height: 32)
                                                    Image(systemName: "pencil")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.white)
                                                }
                                                .offset(x: -5, y: -5)
                                            }
                                        }
                                        .frame(width: 95, height: 95)
                                    }
                                    
                                    Button(action: {
                                        // Change photo action
                                    }) {
                                        Text("Change Photo")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 12)
                                            .background(
                                                Capsule()
                                                    .fill(Color.blue.opacity(0.1))
                                            )
                                    }
                                }
                                .padding(.vertical, 24)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Username Section
                        VStack(spacing: 16) {
                            Text("Username")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(alignment: .leading)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 18))
                                        
                                        TextField("Username", text: .constant("blabla"))
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.08))
                                    )
                                    
                                    Button(action: {
                                        // Save username action
                                    }) {
                                        Text("Save Username")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Danger Zone Section
                        VStack(spacing: 16) {
                            Text("Danger Zone")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.red)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.red.opacity(0.1), radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size: 18))
                                        
                                        Text("Delete all saved data and reset account")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black.opacity(0.7))
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.red.opacity(0.05))
                                    )
                                    
                                    Button(action: {
                                        // Delete account
                                    }) {
                                        Text("Delete Account")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView()
}
