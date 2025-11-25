//
//  prjTradingCardApp.swift
//  prjTradingCard
//
//  Created by Danh on 2025-11-02.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    AudioManager.shared.playBackgroundMusic(fileName: "Persona2", fileType: "mp3")
    return true
  }
}


@main
struct prjTradingCardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var socialViewModel = SocialViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthManager())
                .environmentObject(socialViewModel)
        }
    }
}
