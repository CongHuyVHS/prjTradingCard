//
//  ContentView.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    var body: some View {
        LoginView()
            .environmentObject(authManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
