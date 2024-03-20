//
//  NewHomeView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import PhotosUI
import SwiftUI

struct NewHomeView<AuthManager: AuthenticationManaging, RecipeRecognizer: RecipeRecognitionHandling>: View {
    // MARK: - Environment
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var recipeRecognitionHandler: RecipeRecognizer

    // MARK: - State
    @StateObject var homeViewModel = NewHomeViewModel(coreDataController: CoreDataController.shared)

    // MARK: - Properties
    @FetchRequest(fetchRequest: Recipe.all()) private var recipes
    var coreDataController = CoreDataController.shared

    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            mainView
                .toolbar {
                    mainViewToolbar
                }
//                .photosPicker(isPresented: $homeViewModel.presentPhotosPicker,
//                              selection: $homeViewModel.selectedPhotosPickerItem, photoLibrary: .shared())
//                .navigationDestination(for: String.self) { _ in
//                    SettingsView<SettingsViewModel, AuthManaging>(path: $homeViewModel.path)
//                }
        }
        .environmentObject(homeViewModel)
        .environmentObject(recipeRecognitionHandler)
    }

    // MARK: - Subviews
    private var mainView: some View {
        Group {
//            if recipes.isEmpty {
//                emptyRecipesView
//            } else {
//                recipesView
//            }
            recipesView
        }
        .overlay {
            if recipeRecognitionHandler.recognitionInProgress {
                ProgressView()
                    .tint(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 60, height: 60)
                            .opacity(0.6)
                    }
            }
        }
    }

    private var emptyRecipesView: some View {
        VStack {
            Text("Tap the plus to get started! ☝️")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .frame(width: 300)
                .frame(minHeight: 600)
        }
    }

    private var recipesView: some View {
        List {
            ForEach(recipes) { recipe in
                NavigationLink {
                    VStack {
                        Text(recipe.title)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)

                        HStack(spacing: 5) {
                            Group {
                                Text("^[\(recipe.ingredientsArr.count) item](inflect: true)")
                                Text("•")
                                Text("makes \(recipe.yield)")
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .swipeActions {
                    Button(role: .destructive) {
                        do {
                            try coreDataController.delete(recipe, in: coreDataController.viewContext)
                        } catch {
                            print("Error deleting card: \(error.localizedDescription)")
                        }
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }

                    Button {
//                        homeViewModel.selectedCard = ingredientCard
//                        homeViewModel.sheet = .editCard
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)

                    Button {
//                        homeViewModel.selectedCard = ingredientCard
//                        homeViewModel.sheet = .editCard
                    } label: {
                        Label("Shop", systemImage: "basket")
                    }
                    .tint(.blue)
                }
            }
        }
        .listRowSpacing(10)
    }

    private var mainViewToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Image("grocemateLogoSmall")
                    .imageScale(.large)
                    .shadow(radius: 2)
                    .drawingGroup()
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        homeViewModel.sheet = .documentScanner
                    } label: {
                        HStack {
                            Text("Scan a Recipe")
                            Image(systemName: "doc.viewfinder")
                        }
                    }

                    Button {
                        homeViewModel.presentPhotosPicker = true
                    } label: {
                        HStack {
                            Text("Select from Photos")
                            Image(systemName: "photo.stack")
                        }
                    }

                    Button {
                        homeViewModel.sheet = .manuallyCreateCard
                    } label: {
                        HStack {
                            Text("Manually Add Recipe")
                            Image(systemName: "character.cursor.ibeam")
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .accessibilityLabel("Add a new card.")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section("Sort By") {
                        Button {
                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.titleAsc)
                            }
                        } label: {
                            HStack {
                                Text("Title, Ascending")
                                Image(systemName: "character.cursor.ibeam")
                            }
                        }
                        Button {
                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.titleDesc)
                            }
                        } label: {
                            HStack {
                                Text("Title, Descending")
                                Image(systemName: "character.cursor.ibeam")
                            }
                        }
                        Button {
                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.timestampAsc)
                            }
                        } label: {
                            HStack {
                                Text("Date, Ascending")
                                Image(systemName: "character.cursor.ibeam")
                            }
                        }
                        Button {
                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.timestampDesc)
                            }
                        } label: {
                            HStack {
                                Text("Date, Descending")
                                Image(systemName: "character.cursor.ibeam")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.and.down.text.horizontal")
                        .font(.system(size: 16, weight: .semibold))
                }

            }
        }
    }

    @ViewBuilder private func makeSheet(_ sheet: Sheets) -> some View {
        switch sheet {
        case .imageROI:
            if let image = homeViewModel.selectedImage {
                ImageWithROI(image: image)
            } else {
                EmptyView()
            }
        case .editCard:
            if let selectedCard = homeViewModel.selectedCard {
                CardDetailView<EditCardViewModel>(viewModel:
                                                    EditCardViewModel(
                                                        coreDataController: .shared,
                                                        ingredientCard: selectedCard
                                                    )
                )
            }
        case .manuallyCreateCard:
            CardDetailView<CreateCardViewModel>(
                viewModel: CreateCardViewModel(coreDataController: .shared, context: coreDataController.newContext)
            )
        case .documentScanner:
            DocumentScanner { images in
//                Task {
//                    var recognizedText: [String] = [String]()
//                    for image in images {
//
//                    }
//                    print(recognizedText)
//                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview("Recipes Tab with Data") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        NewHomeView<AuthenticationManager, RecipeRecognitionHandler<ImageToTextHandler, ChatGPTCloudFunctionsHandler>>()
            .environmentObject(AuthenticationManager())
            .environmentObject(RecipeRecognitionHandler())
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                Recipe.makePreview(count: 2, in: preview.viewContext)
            }
    }()

    return viewToPreview
}

#Preview("Empty Recipes Tab") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        NewHomeView<AuthenticationManager, RecipeRecognitionHandler<ImageToTextHandler, ChatGPTCloudFunctionsHandler>>()
            .environmentObject(AuthenticationManager())
            .environmentObject(RecipeRecognitionHandler())
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                Recipe.makePreview(count: 0, in: preview.viewContext)
            }
    }()

    return viewToPreview
}
