import SwiftUI

struct HomeView: View {
    @State private var showPackOpening = false
    @StateObject private var viewModel = HomeViewModel()
    @State private var goToSettings = false
    
    var body: some View {
        // Wrap the entire UI in a NavigationStack so NavigationLink will work
        NavigationStack {
            
            ZStack {
                // background color
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
                        // header
                        HStack {
                            VStack(spacing: 5) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 80)
                                    
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
                                    
                                    if let pfpName = viewModel.user?.pfp {
                                        Image(pfpName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                            .shadow(radius: 7)
                                    } else {
                                        
                                        Text("Loading...")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                        
                                    }
                                }
                                
                                if let username = viewModel.user?.username {
                                    Text(username)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                } else {
                                    Text("Loading...")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                IconButton(iconName: "envelope.fill", backgroundColor: Color.white)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                        
                        // pack opening
                        PackOpeningSectionView(showPackOpening: $showPackOpening)
                            .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // bottom Bar
                VStack {
                    
                    Spacer()
                    HStack {
                        NavigationButton(iconName: "house.fill", isSelected: true)
                        NavigationButton(iconName: "rectangle.grid.2x2.fill", isSelected: false)
                        NavigationButton(iconName: "person.2.fill", isSelected: false)
                        NavigationButton(iconName: "line.3.horizontal", isSelected: false) { goToSettings = true }
                            
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
                    .background(
                        ZStack {
                            // frosted material
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(.ultraThinMaterial)

                            // soft tint gradient for color/depth
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.06), Color.blue.opacity(0.04)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blendMode(.overlay)

                            // subtle white stroke for edge
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                .blur(radius: 0.5)
                                .blendMode(.overlay)

                            // glossy highlight
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.18), Color.white.opacity(0.03)]),
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                                
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .padding(.horizontal, 12)
                }
            }
            .fullScreenCover(isPresented: $showPackOpening) {
                PackOpeningView()
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadUser()
            }
            .navigationDestination(isPresented: $goToSettings) {
                SettingsView()
            }
            
        }
    }
}

struct PackOpeningSectionView: View {
    @Binding var showPackOpening: Bool
    
    var body: some View {
        ZStack {
            // card background with gradient
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
                // pack images (placeholder, will put actual images later)
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
                
                // timer and button
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.gray)
                        Text("06 hr 07 min")
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
                            Text("le anh jeff")
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
            
            
        }
        .frame(height: 280)
    }
}

// Add missing IconButton used in the header
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

// Add missing PackCardView used by the pack carousel
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

                // pack title
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

            // subtle decorative bubbles
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
