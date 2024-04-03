//
//  GrocemateTabView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import SwiftUI

struct TabsControllerView<AuthManaging: AuthenticationManaging>: View {
    // MARK: - Environment
    @EnvironmentObject var authManager: AuthManaging
    var isPremium: Bool = true

    var body: some View {
        TabView {
            RecipesView(isEntitled: authManager.isUserAuthenticated && isPremium)
                .tabItem {
                    Label("Recipes", systemImage: "newspaper")
                }

            SettingsView<SettingsViewModel, AuthManaging>()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
