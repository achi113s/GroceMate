//
//  LoginView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/10/24.
//

import SwiftUI

struct AuthenticationView<AuthManaging: AuthenticationManaging>: View {
    @EnvironmentObject var authManager: AuthManaging

    init() { }

    var body: some View {
        VStack {
            Spacer()

            Image("grocemateLogo")
                .imageScale(.large)
                .shadow(radius: 2)

            Spacer()

            Button {
                Task {
                    do {
                        try await authManager.signInWithApple()
                        await authManager.setAuthStatusTrue()
                    } catch {
                        print("error signing in with apple: \(error)")
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .continue, style: .whiteOutline)
                    .allowsHitTesting(false)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
            }
            .frame(height: 55, alignment: .bottom)
        }
        .padding()
    }
}

#Preview {
    @StateObject var authManager = AuthenticationManager()

    let authView: some View = {
        AuthenticationView<AuthenticationManager>()
            .environmentObject(authManager)
    }()

    return authView
}
