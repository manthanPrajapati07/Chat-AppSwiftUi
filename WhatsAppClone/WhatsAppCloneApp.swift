//
//  WhatsAppCloneApp.swift
//  WhatsAppClone
//
//  Created by Manthan on 13/05/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
          
    FirebaseApp.configure()
    Auth.auth().settings?.isAppVerificationDisabledForTesting = true
    
    return true
  }
}

@main
struct WhatsAppCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
