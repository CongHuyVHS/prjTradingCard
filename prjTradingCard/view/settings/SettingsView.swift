//
//  SettingsView.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-20.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @ObservedObject private var audioManager = AudioManager.shared
    @State private var showPfpPicker = false
    @State private var currentPfp = "tcgpfp"
    @State private var isLoadingPfp = true
    @State private var currentUsername = ""
    @State private var isLoadingUsername = true
    @State private var isSavingUsername = false
    @State private var usernameError: String?
    @State private var showUsernameSuccess = false
    @State private var showDeleteAlert = false
    @State private var isDeletingAccount = false
    
    var body: some View {
        ZStack {
            
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
                    
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // pfp section
                        VStack(spacing: 16) {
                            Text("Profile Picture")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 20) {
                                    // pfp display
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
                                        
                                        if isLoadingPfp {
                                            ProgressView()
                                                .frame(width: 95, height: 95)
                                        } else {
                                            Image(currentPfp)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 95, height: 95)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        }
                                        
                                        // camera
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
                                        showPfpPicker = true
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
                        
                        // username section
                        VStack(spacing: 16) {
                            Text("Username")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(alignment: .leading)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black, radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 18))
                                        
                                        if isLoadingUsername {
                                            ProgressView()
                                                .padding(.leading, 8)
                                            Spacer()
                                        } else {
                                            TextField("Username", text: $currentUsername)
                                                .font(.system(size: 16))
                                                .foregroundColor(.black)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                                .onChange(of: currentUsername) { _ in
                                                    usernameError = nil
                                                    showUsernameSuccess = false
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray)
                                    )
                                    
                                    // error/success message
                                    if let error = usernameError {
                                        HStack {
                                            Image(systemName: "exclamationmark.circle.fill")
                                                .foregroundColor(.red)
                                            Text(error)
                                                .font(.system(size: 14))
                                                .foregroundColor(.red)
                                            Spacer()
                                        }
                                    }
                                    
                                    if showUsernameSuccess {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            Text("Username updated successfully!")
                                                .font(.system(size: 14))
                                                .foregroundColor(.green)
                                            Spacer()
                                        }
                                    }
                                    
                                    Button(action: saveUsername) {
                                        if isSavingUsername {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            Text("Save Username")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.yellow]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                                    .disabled(isSavingUsername)
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        
                        VStack(spacing: 16) {
                            Text("Log out of your account")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)

                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black, radius: 10, x: 0, y: 4)

                                VStack(spacing: 16) {
                                
                                    Button(action: {
                                        authManager.logout()
                                        dismiss()
                                    }) {
                                        Text("Logout")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(.gray)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Music Settings Section
                        VStack(spacing: 16) {
                            Text("Music Settings")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black, radius: 10, x: 0, y: 4)
                                
                                VStack(spacing: 20) {
                                    // music Toggle
                                    HStack {
                                        Image(systemName: "music.note")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 20))
                                        
                                        Text("Background Music")
                                            .font(.system(size: 16))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Toggle("", isOn: Binding(
                                            get: { audioManager.isMusicPlaying },
                                            set: { _ in audioManager.toggleMusic() }
                                        ))
                                        .labelsHidden()
                                    }
                                    
                                    Divider()
                                    
                                    // song selection
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "music.note.list")
                                                .foregroundColor(.purple)
                                                .font(.system(size: 18))
                                            
                                            Text("Select Song")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.black)
                                        }
                                        
                                        VStack(spacing: 8) {
                                            ForEach(audioManager.availableSongs, id: \.name) { song in
                                                Button(action: {
                                                    audioManager.switchSong(to: song.name, fileType: song.fileType)
                                                }) {
                                                    HStack {
                                                        Image(systemName: audioManager.currentSong == song.name ? "checkmark.circle.fill" : "circle")
                                                            .foregroundColor(audioManager.currentSong == song.name ? .blue : .gray)
                                                            .font(.system(size: 20))
                                                        
                                                        Text(song.displayName)
                                                            .font(.system(size: 15))
                                                            .foregroundColor(.black)
                                                        
                                                        Spacer()
                                                        
                                                        if audioManager.currentSong == song.name && audioManager.isMusicPlaying {
                                                            HStack(spacing: 2) {
                                                                ForEach(0..<3) { index in
                                                                    RoundedRectangle(cornerRadius: 2)
                                                                        .fill(Color.blue)
                                                                        .frame(width: 3, height: 12)
                                                                        .animation(
                                                                            Animation.easeInOut(duration: 0.5)
                                                                                .repeatForever()
                                                                                .delay(Double(index) * 0.15),
                                                                            value: audioManager.isMusicPlaying
                                                                        )
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 12)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(audioManager.currentSong == song.name ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                                                    )
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    // Volume slider
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "speaker.fill")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
                                            
                                            Text("Volume")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Text("\(Int(audioManager.volume * 100))%")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Slider(
                                            value: Binding(
                                                get: { audioManager.volume },
                                                set: { audioManager.setVolume($0) }
                                            ),
                                            in: 0...1
                                        )
                                        .tint(.blue)
                                    }
                                }
                                .padding(20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Danger Zone section
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
                                            .foregroundColor(.black)
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
                                        showDeleteAlert = true
                                    }) {
                                        if isDeletingAccount {
                                            ProgressView()
                                                .tint(.white)
                                        } else {
                                            Text("Delete Account")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.red)
                                    .cornerRadius(12)
                                    .disabled(isDeletingAccount)
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
        .sheet(isPresented: $showPfpPicker) {
            ProfilePicturePickerView(selectedPfp: $currentPfp, isPresented: $showPfpPicker)
                .environmentObject(authManager)
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.")
        }
        .onAppear {
            loadCurrentPfp()
            loadCurrentUsername()
        }
    }
    
    private func loadCurrentPfp() {
        isLoadingPfp = true
        authManager.getUserPfp { pfpName in
            if let pfpName = pfpName {
                currentPfp = pfpName
            }
            isLoadingPfp = false
        }
    }
    

    private func loadCurrentUsername() {
        isLoadingUsername = true
        authManager.getUsername { username in
            if let username = username {
                currentUsername = username
            }
            isLoadingUsername = false
        }
    }
    
    
    private func saveUsername() {
        
        usernameError = nil
        showUsernameSuccess = false
        
        
        let trimmedUsername = currentUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedUsername.isEmpty else {
            usernameError = "Username cannot be empty"
            return
        }
        
        guard trimmedUsername.count >= 3 else {
            usernameError = "Username must be at least 3 characters"
            return
        }
        
        guard trimmedUsername.count <= 20 else {
            usernameError = "Username must be less than 20 characters"
            return
        }
        
        // check for valid characters
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        guard trimmedUsername.unicodeScalars.allSatisfy({ allowedCharacters.contains($0) }) else {
            usernameError = "Username can only contain letters, numbers, and underscores"
            return
        }
        
        isSavingUsername = true
        
        authManager.updateUsername(trimmedUsername) { error in
            isSavingUsername = false
            
            if let error = error {
                if let authError = error as? AuthError {
                    usernameError = authError.errorDescription
                } else {
                    usernameError = error.localizedDescription
                }
            } else {
                // success
                withAnimation {
                    showUsernameSuccess = true
                }
                
                // hide success message after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showUsernameSuccess = false
                    }
                }
            }
        }
    }
    

    private func deleteAccount() {
        isDeletingAccount = true
        
        authManager.deleteAccount { error in
            isDeletingAccount = false
            
            if let error = error {
                usernameError = "Failed to delete account: \(error.localizedDescription)"
            } else {
                
                dismiss()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
}
