//
//  GrocemateTabView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import SwiftUI

struct GrocemateTabView<AuthManaging: AuthenticationManaging>: View {
    // MARK: - Environment
    @EnvironmentObject var authManager: AuthManaging

    var body: some View {
        TabView {
            
        }
    }
}

#Preview("Main View with Data") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        HomeView<AuthenticationManager>()
            .environmentObject(AuthenticationManager())
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                IngredientCard.makePreview(count: 2, in: preview.viewContext)
            }
    }()

    return viewToPreview
}

#Preview("Empty Main View") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        HomeView<AuthenticationManager>()
            .environmentObject(AuthenticationManager())
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                IngredientCard.makePreview(count: 0, in: preview.viewContext)
            }
    }()

    return viewToPreview
}
