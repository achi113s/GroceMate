//
//  AuthenticationManager.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/27/24.
//

import Firebase
import FirebaseAuth
import SwiftUI

struct AuthDataResultModel {
    let uid: String
    let email: String?

    init(_ user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

enum AuthProviderOption: String {
    case apple = "apple.com"
}

protocol AuthenticationManaging: ObservableObject {
    func signOut() async throws
    func signInWithApple() async throws
    func setAuthStatusFalse() async
    func setAuthStatusTrue() async

    var userIsAuthenticated: Bool { get async }
}

@MainActor final class AuthenticationManager: ObservableObject, AuthenticationManaging {
    @Published public var userIsAuthenticated: Bool = false

    // Not checking the server for authentication. This is a synchronous method!
    func verifyAuthenticationStatus() {
        guard Auth.auth().currentUser != nil else {
            userIsAuthenticated = false
            return
        }

        userIsAuthenticated = true
    }

    // Not checking the server for authentication. This is a synchronous method!
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user)
    }

    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }

        // Users have the ability to sign in with more than one provider, which
        // is why providerData is an array.
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Error: Encountered unexpected sign-in provider option: \(provider.providerID)")
            }
        }

        return providers
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }

        try await user.delete()
    }

    func setAuthStatusFalse() {
        self.userIsAuthenticated = false
    }

    func setAuthStatusTrue() {
        self.userIsAuthenticated = true
    }
}

// MARK: - Sign In SSO
extension AuthenticationManager {
    func signInWithApple() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try await self.signInWithApple(tokens: tokens)
    }

    @discardableResult
    private func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)
        return try await signIn(with: credential)
    }

    func reauthenticateAppleSignIn() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try self.reauthenticateAppleSignIn(tokens: tokens)
    }

    private func reauthenticateAppleSignIn(tokens: SignInWithAppleResult) throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }

        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)

        user.reauthenticate(with: credential)
    }

    func signIn(with credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(authDataResult.user)
    }
}
