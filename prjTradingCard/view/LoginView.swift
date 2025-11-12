
//
//  LoginView.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-03.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @EnvironmentObject var authManager: AuthManager

    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    // title
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        
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
                        Button(action: handleLogin ) {
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
                            
                            NavigationLink(destination: SignUp()) {
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
                    
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(AuthManager())
    }
}
