//
//  GrocemateTabView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import SwiftUI

struct MainTabView<AuthManaging: AuthenticationManaging>: View {
    // MARK: - Environment
    @EnvironmentObject var authManager: AuthManaging

    var body: some View {
        TabView {
            NewHomeView(isAuthenticated: authManager.isUserAuthenticated)
                .tabItem {
                    Label("Recipes", systemImage: "newspaper")
                }
        }
    }
}
