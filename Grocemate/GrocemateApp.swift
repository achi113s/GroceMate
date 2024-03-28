//
//  GrocemateApp.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/5/23.
//

import Firebase
import FirebaseAppCheck
import FirebaseFunctions
import SwiftUI

@main
struct GrocemateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var hapticEngine: HapticEngine = HapticEngine()
    @StateObject private var authManager: AuthenticationManager = AuthenticationManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(hapticEngine)
                .environmentObject(authManager)
                .environment(\.managedObjectContext, CoreDataController.shared.viewContext)
                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
#if DEBUG
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
#endif

            FirebaseApp.configure()
#if DEBUG
            Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
            Functions.functions().useEmulator(withHost: "127.0.0.1", port: 5001)
#endif

            return true
        }
}
