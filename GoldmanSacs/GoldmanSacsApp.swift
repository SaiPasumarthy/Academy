//
//  GoldmanSacsApp.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 24/04/26.
//

import SwiftUI
import Firebase

@main
struct GoldmanSacsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        FirebaseApp.configure()
//        print("Configured Firebase")
//    }
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
  }
}
