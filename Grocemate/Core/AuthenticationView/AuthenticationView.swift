//
//  LoginView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/10/24.
//

import SpriteKit
import SwiftUI

struct AuthenticationView<A: AuthenticationManaging>: View {
    @EnvironmentObject var authManager: A

    @State private var logoScale: CGSize = .zero

    var scene: SKScene {
        let scene = FoodSim()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Spacer()

                Image("grocemateLogo")
                    .imageScale(.large)
                    .shadow(radius: 2)
                    .scaleEffect(logoScale)

                Spacer()

                signInButton
            }
            .padding()
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.5)) {
                logoScale = CGSize(width: 1, height: 1)
            }
        }
    }

    private var signInButton: some View {
        Button {
            Task {
                do {
                    try await authManager.signInWithApple()
                } catch {
                    print("error signing in with apple: \(error)")
                }
            }
        } label: {
            SignInWithAppleButtonViewRepresentable(type: .continue, style: .whiteOutline)
                .allowsHitTesting(false)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
        }
        .frame(height: 55, alignment: .bottom)
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
