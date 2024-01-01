//
//  TestHomeView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/31/23.
//

import PhotosUI
import SwiftUI

struct TestHomeView: View {
    // MARK: - State
    @StateObject var homeViewModel = HomeViewModel(coreDataController: CoreDataController.shared)
    @StateObject var ingredientRecognitionHandler: IngredientRecognitionHandler = IngredientRecognitionHandler(
        openAIManager: OpenAIManager()
    )

    // MARK: - Properties
    @FetchRequest(fetchRequest: IngredientCard.all()) private var ingredientCards
    var coreDataController = CoreDataController.shared

    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            ingredientCardsView
        }
        .environmentObject(homeViewModel)
        .environmentObject(ingredientRecognitionHandler)
    }

    // MARK: - Subviews
    private var mainView: some View {
        ScrollView(.vertical) {
            if ingredientCards.isEmpty {
                emptyIngredientCardsView
            } else {
                ingredientCardsView
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
            }
        }
    }

    private var emptyIngredientCardsView: some View {
        VStack {
            Text("Tap the plus to get started! ☝️")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .frame(width: 300)
                .frame(minHeight: 600)
        }
    }

    //    private var ingredientCardsView: some View {
    //        LazyVStack(alignment: .center) {
    //            ForEach(ingredientCards) { ingredientCard in
    //                Card(ingredientCard: ingredientCard)
    //                    .padding(.bottom, 15)
    //            }
    //        }
    //    }
    private var ingredientCardsView: some View {
        List {
            ForEach(ingredientCards) { ingredientCard in
                VStack(alignment: .leading, spacing: 10) {
                    Text(ingredientCard.title)
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)

                    ForEach(ingredientCard.ingredientsArr) { ingredient in
                        HStack(alignment: .center) {
                            SwipeableIngredient(ingredient: ingredient)
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .listRowBackground(Color.clear)
        }
    }
}

#Preview("Main View with Data") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        TestHomeView()
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
        TestHomeView()
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                IngredientCard.makePreview(count: 0, in: preview.viewContext)
            }
    }()

    return viewToPreview
}
