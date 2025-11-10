import SwiftUI

struct PackData: Identifiable {
    let id = UUID()
    let name: String
    let colors: [Color]
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
        index == selectedIndex ? 1.0 : 0.6
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
            
            VStack {
                Spacer()
                
                // Pack branding at bottom
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
            
            // Decorative elements
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: -40, y: -80)
            
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 150, height: 150)
                .offset(x: 50, y: -100)
            
            // Center icon
            Image(systemName: "flame.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white.opacity(0.3))
                .offset(y: -30)
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
    @State private var revealedCards: [Int] = []
    @State private var showAllCards = false
    
    // Simulated card data
    let cards = Array(0..<5)
    
    var body: some View {
        ZStack {
            // Dark background with particles
            Color.black
                .ignoresSafeArea()
            
            if !showAllCards {
                // Pack opening animation
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showAllCards = true
                        }
                    }
                }
            } else {
                // Card reveal
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Text("Done")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                )
                        }
                        
                        Spacer()
                        
                        Text("\(packName)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Placeholder for symmetry
                        Color.clear.frame(width: 80)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(cards, id: \.self) { index in
                                RevealedCardView(cardIndex: index)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding()
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

struct RevealedCardView: View {
    let cardIndex: Int
    @State private var isFlipped = false
    
    let rarityColors: [Color] = [
        Color.gray,      // Common
        Color.green,     // Uncommon
        Color.blue,      // Rare
        Color.purple,    // Epic
        Color.orange     // Legendary
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            rarityColors[cardIndex % rarityColors.count],
                            rarityColors[cardIndex % rarityColors.count].opacity(0.7)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 240)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
                .shadow(color: rarityColors[cardIndex % rarityColors.count].opacity(0.5), radius: 10, x: 0, y: 5)
            
            VStack {
                Spacer()
                Text("Card \(cardIndex + 1)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
            
            // Shine effect
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 80, height: 80)
                .offset(x: -30, y: -50)
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 0 : 90),
            axis: (x: 0, y: 1, z: 0)
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(cardIndex) * 0.1)) {
                isFlipped = true
            }
        }
    }
}

struct PackOpeningComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PackView3D(pack: PackData(name: "Mega Gyarados", colors: [Color.blue, Color.cyan]), index: 1, selectedIndex: 1, totalPacks: 3)
                .frame(height: 340)
            CardRevealView(packName: "Mega Gyarados")
                .frame(height: 300)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
