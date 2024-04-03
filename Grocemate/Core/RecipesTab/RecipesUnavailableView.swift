//
//  RecipesUnavailableView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 4/2/24.
//

import SwiftUI

extension RecipesView {
    @available(iOS 17.0, *)
    internal var emptyRecipesViewiOS17: some View {
        ContentUnavailableView("No Recipes",
                               systemImage: "newspaper",
                               description: Text("Tap the plus in the top toolbar to get started!"))
        .fontDesign(.rounded)
    }

    internal var emptyRecipesView: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper")
                .font(.system(size: 45))
                .foregroundStyle(.secondary)
            VStack(spacing: 8) {
                Text("No Recipes")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Tap the plus in the top toolbar to get started!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .fontDesign(.rounded)
        }
    }
}
