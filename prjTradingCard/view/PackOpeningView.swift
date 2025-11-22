//
//  PackOpeningView.swift
//  prjTradingCard
//
//  Created by Bu on 2/11/25.
//

import SwiftUI
import UIKit

struct PackOpeningView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CardViewModel()
    @State private var selectedPackIndex = 1
    @State private var showCardReveal = false
    @State private var offset: CGFloat = 0
    
    let packs = [
        PackData(name: "Mega Gyarados", colors: [Color.blue, Color.cyan], isAvailable: false),
        PackData(name: "Mega Blaziken", colors: [Color.orange, Color.red], isAvailable: true),
        PackData(name: "Mega Altaria", colors: [Color.cyan, Color.purple], isAvailable: false)
    ]
    
    var body: some View {
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
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text("Choose a Pack")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // placeholder for symmetry
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // pack Carousel
                ZStack {
                    ForEach(0..<packs.count, id: \.self) { index in
                        PackView3D(
                            pack: packs[index],
                            index: index,
                            selectedIndex: selectedPackIndex,
                            totalPacks: packs.count
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                selectedPackIndex = index
                            }
                        }
                    }
                }
                .frame(height: 450)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                if value.translation.width < -50 && selectedPackIndex < packs.count - 1 {
                                    selectedPackIndex += 1
                                } else if value.translation.width > 50 && selectedPackIndex > 0 {
                                    selectedPackIndex -= 1
                                }
                                offset = 0
                            }
                        }
                )
                
                Spacer()
                
                // pack Info
                VStack(spacing: 15) {
                    Text(packs[selectedPackIndex].name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    if packs[selectedPackIndex].isAvailable {
                        Text("MEGA RISING")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    } else {
                        Text("COMING SOON")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.yellow)
                    }
                    
                    // open Pack Button
                    Button(action: {
                        if packs[selectedPackIndex].isAvailable {
                            showCardReveal = true
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: packs[selectedPackIndex].isAvailable ? "sparkles" : "lock.fill")
                                .font(.system(size: 18))
                            Text(packs[selectedPackIndex].isAvailable ? "Open Pack" : "Coming Soon")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: packs[selectedPackIndex].isAvailable ?
                                    [Color.orange, Color.red] :
                                    [Color.gray, Color.gray.opacity(0.7)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: packs[selectedPackIndex].isAvailable ?
                            Color.orange.opacity(0.5) : Color.clear,
                            radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    .disabled(!packs[selectedPackIndex].isAvailable)
                    
                    // pack indicators
                    HStack(spacing: 10) {
                        ForEach(0..<packs.count, id: \.self) { index in
                            Circle()
                                .fill(index == selectedPackIndex ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            viewModel.fetchCards()
        }
        .fullScreenCover(isPresented: $showCardReveal) {
            CardRevealView(
                packName: packs[selectedPackIndex].name,
                viewModel: viewModel
            )
        }
    }
}

struct PackView3D: View {
    let pack: PackData
    let index: Int
    let selectedIndex: Int
    let totalPacks: Int
    
    var offset: CGFloat {
        let position = CGFloat(index - selectedIndex)
        return position * 140
    }
    
    var scale: CGFloat {
        index == selectedIndex ? 1.0 : 0.75
    }
    
    var opacity: Double {
        if !pack.isAvailable {
            return index == selectedIndex ? 0.5 : 0.3
        }
        return index == selectedIndex ? 1.0 : 0.6
    }
    
    var rotation: Double {
        let position = Double(index - selectedIndex)
        return position * 15
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: pack.colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 220, height: 340)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            
            // Coming Soon Overlay
            if !pack.isAvailable {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 220, height: 340)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                        Text("COMING SOON")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            VStack {
                Spacer()
                
                // pack branding at bottom
                VStack(spacing: 5) {
                    Text("MEGA RISING")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.white)
                    Text(pack.name)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.5))
                )
                .padding(.bottom, 25)
            }
            
            // decorative elements (only if available)
            if pack.isAvailable {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(x: -40, y: -80)
                
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 150, height: 150)
                    .offset(x: 50, y: -100)
                
                // center icon
                Image(systemName: "flame.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.3))
                    .offset(y: -30)
            }
        }
        .scaleEffect(scale)
        .opacity(opacity)
        .offset(x: offset)
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

struct CardRevealView: View {
    @Environment(\.dismiss) var dismiss
    let packName: String
    @ObservedObject var viewModel: CardViewModel
    
    @State private var showAllCards = false
    @State private var pulledCard: Card?
    @State private var isSaving = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if !showAllCards {
                // pack opening animation
                VStack {
                    Spacer()

                    Text("Opening Pack...")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding(.top, 20)

                    Spacer()
                }
                .onAppear {
                    // Pull random card
                    pulledCard = viewModel.pullRandomCard()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showAllCards = true
                        }
                        
                        // Save to Firebase
                        if let card = pulledCard {
                            isSaving = true
                            viewModel.saveCardToUserCollection(card: card) { success in
                                isSaving = false
                                if success {
                                    print("Card saved successfully!")
                                } else {
                                    print("Failed to save card")
                                }
                            }
                        }
                    }
                }
            } else {
                // card reveal
                VStack(spacing: 0) {
                    Spacer()
                    
                    if let card = pulledCard {
                        CardView(currentCard: card)
                            .transition(.scale.combined(with: .opacity))
                            .padding()
                    }
                    
                    if isSaving {
                        HStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Saving to collection...")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
                
                // x button overlay in top left
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct PackOpeninView_Preview: PreviewProvider {
    static var previews: some View {
        PackOpeningView()
    }
}
