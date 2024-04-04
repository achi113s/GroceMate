//
//  RootView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

struct RootView: View {
    // MARK: - State
//    @StateObject private var hapticEngine: HapticEngine = HapticEngine()
    @StateObject private var authManager: AuthenticationManager = AuthenticationManager()

    var body: some View {
        Group {
            if !authManager.isUserAuthenticated {
                AuthenticationView<AuthenticationManager>()
            } else {
                TabsControllerView<AuthenticationManager>()
            }
//            AuthenticationView<AuthenticationManager>()
        }
        .animation(.easeInOut, value: authManager.isUserAuthenticated)
        .transition(.push(from: .bottom))
        .environmentObject(authManager)
//        .environmentObject(hapticEngine)
    }
}

#Preview {
    RootView()
        .environmentObject(AuthenticationManager())
}
