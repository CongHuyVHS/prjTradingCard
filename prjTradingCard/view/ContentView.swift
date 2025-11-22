//
//  ContentView.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    var body: some View {
        NavigationStack {
            
            if isLoggedIn {
                HomeView()
                
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
