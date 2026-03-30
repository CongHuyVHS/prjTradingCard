//
//  SignUp.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-06.
//

import SwiftUI

struct SignUp: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            // background
            LinearGradient(
                gradient: Gradient(colors: [.red,.yellow, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Title
                VStack(spacing: 10) {
                    Image("signup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .shadow(radius: 10)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                .padding(.bottom, 30)
                
                // signUp
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        SecureField("", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Button(action: handleSignUp) {
                        Text("Create account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                    
                    
                    HStack {
                        Text("Already have an account? ")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Sign in")
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func handleSignUp() {
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter all the required fields"
            return
        }
        
        guard username.count >= 3 else {
            errorMessage = "Username must be at least 3 characters"
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email."
            return
        }
        
        errorMessage = nil
        
        authManager.register(email: email, username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Registration success")
                    dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}


#Preview {
    SignUp()
        .environmentObject(AuthManager())
}

