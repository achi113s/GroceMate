//
//  LoginViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/27/24.
//

import SwiftUI

@MainActor final class SignInViewModel: ObservableObject {
    let signInWithAppleHelper: SignInWithAppleHelper = SignInWithAppleHelper()

    func signInWithApple() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    }
}

