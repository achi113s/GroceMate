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

    var body: some View {
        VStack {
            Spacer()

            Text("Grocemate")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            .foregroundStyle(.blue)

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
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
        }
        .padding()
    }
}

#Preview {
    SignInView(showSignInView: .constant(true))
}
