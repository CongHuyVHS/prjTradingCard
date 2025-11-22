
//
//  LoginView.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-03.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var showSignUp = false
    @EnvironmentObject var authManager: AuthManager

    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.yellow, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // title
                VStack(spacing: 10) {
                    Image("login")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .shadow(radius: 10)
                    
                    Text("Doodlemon TCG")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Login to continue")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                
                // login Form
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
                    }
                    
                    // password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        SecureField("", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                    }
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // login Button
                    Button(action: handleLogin) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .background(Color.black)
                    .cornerRadius(10)
                    
                    // signup Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showSignUp = true
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.yellow)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationDestination(isPresented: $showSignUp) {
            SignUp(isLoggedIn: $isLoggedIn)
        }
    }
    
    
    private func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in Email and Password"
            return
        }
        
        errorMessage = nil
        
        authManager.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Login success")
                    isLoggedIn = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
        .environmentObject(AuthManager())
}
