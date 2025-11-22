//
//  AuthManager.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-07.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    
    @Published var user: FirebaseAuth.User?
    
    private let db = Firestore.firestore()
    
    init() {
        self.user = nil
    }
    
    //  Register
    func register(email: String, username: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        
        //to check if username it already taken or no
        checkUsernameAvailable(username) { [weak self] isAvailable in
            guard let self = self else { return }
            
            if !isAvailable {
                completion(.failure(AuthError.usernameAlreadyExists))
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    completion(.failure(error))
                } else if let user = result?.user {
                    
                    self.createUserDocument(userId: user.uid, email: email, username: username) { firestoreError in
                        if let firestoreError = firestoreError {
                            completion(.failure(firestoreError))
                        } else {
                            self.user = user
                            completion(.success(user))
                        }
                    }
                }
            }
        }
    }
    
    // login
    func login(email: String, password: String, completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                self.user = user
                completion(.success(user))
            }
        }
    }
    
    // logout
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    private func checkUsernameAvailable(_ username: String, completion: @escaping (Bool) -> Void) {
            db.collection("users")
                .whereField("username", isEqualTo: username.lowercased())
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error checking username: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        let isAvailable = (snapshot?.documents.isEmpty ?? true)
                        completion(isAvailable)
                    }
                }
        }
    
    // creation of document in firestore under the Users Collection
    private func createUserDocument(userId: String, email: String, username: String, completion: @escaping (Error?) -> Void) {
            let userData: [String: Any] = [
                "userId": userId,
                "email": email,
                "username": username.lowercased(),
                "pfp": "tcgpfp"
            ]
            
            db.collection("users").document(userId).setData(userData) { error in
                completion(error)
            }
        }
    
    
    func getUsername(completion: @escaping (String?) -> Void) {
           guard let userId = user?.uid else {
               completion(nil)
               return
           }
           
           db.collection("users").document(userId).getDocument { snapshot, error in
               if let error = error {
                   print("Error getting username: \(error.localizedDescription)")
                   completion(nil)
               } else {
                   let username = snapshot?.data()?["username"] as? String
                   completion(username)
               }
           }
       }
    
    
    func updateProfilePfp(_ pfpName: String, completion: @escaping (Error?) -> Void) {
        guard let userId = user?.uid else {
            completion(AuthError.emptyFields)
            return
        }
        
        db.collection("users").document(userId).updateData([
            "pfp": pfpName
        ]) { error in
            completion(error)
        }
    }
    
    func getUserPfp(completion: @escaping (String?) -> Void) {
        guard let userId = user?.uid else {
            completion(nil)
            return
        }
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let pfp = data["pfp"] as? String {
                completion(pfp)
            } else {
                completion(nil)
            }
        }
    }
    
    
}

// Auth Errors
enum AuthError: LocalizedError {
    case usernameAlreadyExists
    case emptyFields
    case usernameTooShort
    
    var errorDescription: String? {
        switch self {
        case .usernameAlreadyExists:
            return "This username is already taken"
        case .emptyFields:
            return "Please fill in all fields"
        case .usernameTooShort:
            return "Username must be at least 3 characters"
        }
    }
}
