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
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Title
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                .padding(.bottom, 30)
                
                // SignUp
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.9))
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
                            .background(Color.white.opacity(0.9))
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
                            .background(Color.white.opacity(0.9))
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
                    
                    
                    HStack{
                        Text("Already have an account? ")
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.bold)
                        
                        NavigationLink(destination: LoginView()) {
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


struct SignUp_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUp()
                .environmentObject(AuthManager())
        }
    }
}

