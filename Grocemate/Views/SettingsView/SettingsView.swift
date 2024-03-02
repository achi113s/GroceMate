//
//  SettingsView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/29/24.
//

import SwiftUI

extension SettingsView where S == SettingsViewModel {
    init(path: Binding<NavigationPath>) {
        self.init(viewModel: SettingsViewModel(), path: path)
    }
}

struct SettingsView<S: SettingsViewModelling, AuthManaging: AuthenticationManaging>: View {
    @EnvironmentObject var authManager: AuthManaging

    @StateObject var viewModel: S
    @Binding var path: NavigationPath

    init(viewModel: S, path: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._path = path
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button {
                    path.removeLast()
                    Task {
                        do {
                            try await authManager.signOut()
                            await authManager.setAuthStatusFalse()
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
    @StateObject var authManager = AuthenticationManager()
    @State var path: NavigationPath = NavigationPath()

    let authView: some View = {
        SettingsView<SettingsViewModel, AuthenticationManager>(path: $path)
            .environmentObject(authManager)
    }()

    return authView
}
