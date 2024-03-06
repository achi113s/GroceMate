//
//  RootView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

struct RootView: View {
    // MARK: - Environment
    @EnvironmentObject var authManager: AuthenticationManager

    // MARK: - State

    var body: some View {
        Group {
            if !authManager.isUserAuthenticated {
                AuthenticationView<AuthenticationManager>()
            } else {
                HomeView<AuthenticationManager>()
            }
        }
//        .onAppear {
//            try? authManager.signOut()
//            authManager.verifyAuthenticationStatus()
//        }
        .animation(.easeInOut, value: authManager.isUserAuthenticated)
        .transition(.push(from: .bottom))
    }
}

//#Preview {
//    RootView()
//}
