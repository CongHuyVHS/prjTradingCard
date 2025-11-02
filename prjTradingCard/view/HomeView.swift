//
//  HomeView.swift
//  prjTradingCard
//
//  Created by Bu on 2/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showPackOpening = false
    
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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header with cards and profile
                    HeaderSectionView()
                        .padding(.top, 20)
                    
                    // Pack Opening Section
                    PackOpeningSectionView(showPackOpening: $showPackOpening)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Bottom Navigation Bar
            VStack {
                Spacer()
                BottomNavigationBar()
            }
        }
        .fullScreenCover(isPresented: $showPackOpening) {
            PackOpeningView()
        }
    }
}

struct HeaderSectionView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Left side - Card collection preview
            HStack(spacing: -20) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 50, height: 70)
                    .foregroundColor(.yellow)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 50, height: 70)
                    .foregroundColor(.green)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green, lineWidth: 2)
                    )
                
                // More cards indicator
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
            }
            .padding(.leading, 30)
            
            Spacer()
            
            // Center - Profile Avatar with level
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.blue.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                    
                    // Avatar image (placeholder)
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.red, Color.orange, Color.purple]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 40
                            )
                        )
                        .frame(width: 75, height: 75)
                        .overlay(
                            Image(systemName: "flame.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        )
                }
                
                Text("Lv. 49")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Right side - Action buttons
            HStack(spacing: 15) {
                IconButton(iconName: "tray.fill", backgroundColor: Color.blue.opacity(0.15))
                IconButton(iconName: "envelope.fill", backgroundColor: Color.white)
                IconButton(iconName: "cube.fill", backgroundColor: Color.white)
            }
            .padding(.trailing, 30)
        }
    }
}

struct IconButton: View {
    let iconName: String
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 50, height: 50)
            
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .font(.system(size: 20))
        }
    }
}

struct PackOpeningSectionView: View {
    @Binding var showPackOpening: Bool
    
    var body: some View {
        ZStack {
            // Card background with gradient
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.7, green: 0.8, blue: 1.0),
                            Color(red: 0.5, green: 0.6, blue: 0.9)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                // Pack images
                HStack(spacing: -30) {
                    PackCardView(
                        colors: [Color.blue, Color.cyan],
                        title: "MEGA RISING",
                        subtitle: "Mega Gyarados"
                    )
                    
                    PackCardView(
                        colors: [Color.orange, Color.red],
                        title: "MEGA RISING",
                        subtitle: "Mega Blaziken"
                    )
                    .offset(y: 10)
                    .zIndex(1)
                    
                    PackCardView(
                        colors: [Color.cyan, Color.blue],
                        title: "MEGA RISING",
                        subtitle: "Mega Altaria"
                    )
                }
                .padding(.top, 20)
                
                // Timer and button
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.gray)
                        Text("06 hr 00 min")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.9))
                    )
                    
                    Button(action: {
                        showPackOpening = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "suit.diamond.fill")
                                .foregroundColor(.yellow)
                            Text("56")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                    }
                }
                .padding(.bottom, 20)
            }
            
            // Scroll indicator (top right)
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .padding(.trailing, 15)
                    .padding(.top, 15)
                }
                Spacer()
            }
        }
        .frame(height: 280)
    }
}

struct PackCardView: View {
    let colors: [Color]
    let title: String
    let subtitle: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
            
            VStack {
                Spacer()
                
                // Pack title
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.6))
                )
                .padding(.bottom, 10)
            }
            
            // Decorative pattern
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 60, height: 60)
                .offset(x: -20, y: -40)
            
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 40, height: 40)
                .offset(x: 25, y: -50)
        }
    }
}

struct BottomNavigationBar: View {
    var body: some View {
        HStack(spacing: 0) {
            NavigationButton(iconName: "house.fill", isSelected: true)
            NavigationButton(iconName: "rectangle.grid.2x2.fill", isSelected: false)
            NavigationButton(iconName: "person.2.fill", isSelected: false)
            NavigationButton(iconName: "bag.fill", isSelected: false, hasBadge: true)
            NavigationButton(iconName: "line.3.horizontal", isSelected: false)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
    }
}

struct NavigationButton: View {
    let iconName: String
    let isSelected: Bool
    var hasBadge: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {}) {
                VStack(spacing: 4) {
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            
            if hasBadge {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .offset(x: 8, y: 8)
            }
        }
    }
}

// Floating Mission Button
struct FloatingMissionButton: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {}) {
                    VStack(spacing: 5) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.teal]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: "checklist")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            
                            // Notification badge
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Text("!")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 20, y: -20)
                        }
                        
                        Text("Missions")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 90)
            }
        }
    }
}

#Preview {
    HomeView()
}
