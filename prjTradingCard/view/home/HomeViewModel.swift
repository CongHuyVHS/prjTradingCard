//
//  HomeViewModel.swift
//  prjTradingCard
//
//  Created by Mate Chachkhiani on 2025-11-22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var user: User?

    private let db = Firestore.firestore()

    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error loading user: \(error.localizedDescription)")
                return
            }

            if let data = try? snapshot?.data(as: User.self) {
                DispatchQueue.main.async {
                    self.user = data
                }
            }
        }
    }
}
