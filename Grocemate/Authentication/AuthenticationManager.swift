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

@MainActor final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()

    @Published public var userIsAuthenticated: Bool = false

    private init() { }

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

    func reauthenticateAppleSignIn(tokens: SignInWithAppleResult) throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }

        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)

        user.reauthenticate(with: credential)
    }
}

// MARK: - Sign In SSO
extension AuthenticationManager {
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)
        return try await signIn(with: credential)
    }

    func signIn(with credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(authDataResult.user)
    }
}

