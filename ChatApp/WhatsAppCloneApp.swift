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

        completionHandler(.newData)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
            Task {
                await AppFunctions.setUserOnlineStatus(false)
            }
        }
}

@main
struct WhatsAppCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var authVM = AuthViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    DispatchQueue.main.async {
                        Task {
                            switch newPhase {
                            case .active:
                                print("App became active")
                                await AppFunctions.setUserOnlineStatus(true)
                            case .background:
                                print("App moved to background")
                                await AppFunctions.setUserOnlineStatus(false)
                            case .inactive:
                                print("App became inactive")
                                await AppFunctions.setUserOnlineStatus(false)
                            default:
                                break
                            }
                        }
                    }
                }
        }
        .environmentObject(authVM)
    }
}
