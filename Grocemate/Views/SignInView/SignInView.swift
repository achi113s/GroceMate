//
//  LoginView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/10/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var signInViewModel: SignInViewModel = SignInViewModel()
    @Binding var showSignInView: Bool
    @State private var sliderVal: Double = 20.0
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
                        try await signInViewModel.signInWithApple()
                        showSignInView = false
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
    SignInView(showSignInView: .constant(true))
}
