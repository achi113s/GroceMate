//
//  SettingsView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

extension SettingsView where S == SettingsViewModel {
    init() {
        self.init(viewModel: SettingsViewModel())
    }
}

struct SettingsView<S: SettingsViewModelling, A: AuthenticationManaging>: View {
    @EnvironmentObject var authManager: A

    @StateObject var viewModel: S
//    @Binding var path: NavigationPath

    init(viewModel: S) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $viewModel.settingsPath) {
            List {
                Section("Account") {
                    ListViewLinkButton(labelText: "Log Out") {
                        Task {
                            do {
                                try await authManager.signOut()
                            } catch {
                                print("error signing out: \(error)")
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    @StateObject var authManager = AuthenticationManager()
//    @State var path: NavigationPath = NavigationPath()

    let authView: some View = {
        SettingsView<SettingsViewModel, AuthenticationManager>()
            .environmentObject(authManager)
    }()

    return authView
}
