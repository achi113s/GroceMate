//
//  NewHomeView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import PhotosUI
import SwiftUI

@MainActor struct RecipesView: View {
    // MARK: - State
    @StateObject var homeViewModel = RecipesViewModel(coreDataController: CoreDataController.shared)
    @StateObject var recipeRecognitionHandler: RecipeRecognitionHandler = RecipeRecognitionHandler()

    var isAuthenticated: Bool

    // MARK: - Properties
    @FetchRequest(fetchRequest: Recipe.all()) private var recipes
    var coreDataController = CoreDataController.shared

    init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }

    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            mainView
                .toolbar {
                    mainViewToolbar
                }
                .photosPicker(isPresented: $homeViewModel.presentPhotosPicker,
                              selection: $homeViewModel.selectedPhotosPickerItem, photoLibrary: .shared())
                .sheet(item: $homeViewModel.sheet, content: makeSheet)
        }
        .onChange(of: homeViewModel.selectedPhotosPickerItem) { newPhoto in
            Task {
                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        homeViewModel.selectedImage = uiImage
                        homeViewModel.sheet = .imageROI
                    }
                }
            }
        }
        .onChange(of: recipeRecognitionHandler.recognizedRecipe) { newRecipe in
            guard newRecipe != nil else { return }
            homeViewModel.sheet = .createCardFromRecognizedText
        }
        .environmentObject(homeViewModel)
        .environmentObject(recipeRecognitionHandler)
    }

    // MARK: - Subviews
    private var mainView: some View {
        Group {
            if recipes.isEmpty {
                GeometryReader { geo in
                    ScrollView {
                        if #available(iOS 17.0, *) {
                            emptyRecipesViewiOS17
                                .frame(width: geo.size.width, height: geo.size.height)

                        } else {
                            emptyRecipesView
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                    }
                }
            } else {
                recipesView
            }
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
                        homeViewModel.selectedRecipe = recipe
                        homeViewModel.sheet = .editCard
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
                        if isAuthenticated {
                            homeViewModel.sheet = .documentScanner
                        }
                    } label: {
                        HStack {
                            Text("Scan a Recipe")
                            Image(systemName: "doc.viewfinder")
                        }
                    }

                    Button {
                        if isAuthenticated {
                            homeViewModel.presentPhotosPicker = true
                        }
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
            }
        case .editCard:
            if let selectedRecipe = homeViewModel.selectedRecipe {
                RecipeDetailView(viewModel: EditRecipeViewModel(coreDataController: .shared, 
                                                                recipe: selectedRecipe)
                )
            }
        case .manuallyCreateCard:
            RecipeDetailView(
                viewModel: CreateRecipeViewModel(context: coreDataController.newContext)
            )
        case .createCardFromRecognizedText:
            RecipeDetailView(
                viewModel: CreateRecipeViewModel(decodedRecipe: recipeRecognitionHandler.recognizedRecipe!,
                                                 context: coreDataController.newContext)
            )
        case .documentScanner:
            DocumentScanner { images in
                recipeRecognitionHandler.recognizeRecipeIn(images: images, 
                                                           with: .right,
                                                           in: CGRect(x: 0, y: 0, width: 1, height: 1))
            }
            .ignoresSafeArea()
        }
    }
}

extension RecipesView {
    @available(iOS 17.0, *)
    private var emptyRecipesViewiOS17: some View {
        ContentUnavailableView("No Recipes",
                               systemImage: "newspaper",
                               description: Text("Tap the plus in the top toolbar to get started!"))
        .fontDesign(.rounded)
    }

    private var emptyRecipesView: some View {
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

#Preview("Recipes Tab with Data") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        RecipesView(isAuthenticated: true)
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
        RecipesView(isAuthenticated: false)
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                Recipe.makePreview(count: 0, in: preview.viewContext)
            }
    }()

    return viewToPreview
}
