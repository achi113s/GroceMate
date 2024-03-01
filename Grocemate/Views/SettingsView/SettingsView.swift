//
//  SettingsView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

@MainActor final class SettingsViewModel: ObservableObject {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }

    func deleteUser() async throws {
        try await AuthenticationManager.shared.deleteUser()
    }

    func reauthenticateAppleSignIn() async throws {
        let helper = SignInWithAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        try AuthenticationManager.shared.reauthenticateAppleSignIn(tokens: tokens)
    }
}

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @Binding var path: NavigationPath

    init(path: Binding<NavigationPath>) {
        self._path = path
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button {
                    path.removeLast()
                    Task {
                        do {
                            try viewModel.signOut()
                        } catch {
                            print("error signing out: \(error)")
                        }
                    }
                } label: {
                    Text("Log Out")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .padding()
                }
                .buttonStyle(PolishedButtonStyle(color: .red))
            }
        }
    }
}

#Preview {
    @State var path: NavigationPath = NavigationPath()
    return SettingsView(path: $path)
}
