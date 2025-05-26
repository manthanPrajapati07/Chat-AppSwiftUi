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
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }

        // Your other handling logic
        completionHandler(.newData)
    }
}

@main
struct WhatsAppCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authVM = AuthViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(authVM)
    }
}
