//
//  RootView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

struct RootView: View {
    @State private var userNotAuthenticated: Bool = true

    var body: some View {
        Group {
            if userNotAuthenticated {
                SignInView(showSignInView: $userNotAuthenticated)
            } else {
                HomeView()
            }
        }
        .onAppear {
//            try? AuthenticationManager.shared.signOut()
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.userNotAuthenticated = authUser == nil
        }
        .animation(.easeInOut, value: self.userNotAuthenticated)
        .transition(.push(from: .bottom))
    }
}

#Preview {
    RootView()
}
