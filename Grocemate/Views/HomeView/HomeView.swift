//
//  ContentView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import PhotosUI
import SwiftUI

//struct HomeView<AuthManaging: AuthenticationManaging>: View {
//    // MARK: - Environment
//    @EnvironmentObject var authManager: AuthManaging
//
//    // MARK: - State
//    @StateObject var homeViewModel = HomeViewModel(coreDataController: CoreDataController.shared)
//    @StateObject var recipeRecognitionHandler: RecipeRecognitionHandler = RecipeRecognitionHandler()
//
//    // MARK: - Properties
//    @FetchRequest(fetchRequest: IngredientCard.all()) private var ingredientCards
//    var coreDataController = CoreDataController.shared
//
//    var body: some View {
//        NavigationStack(path: $homeViewModel.path) {
//            mainView
//                .toolbar {
//                    mainViewToolbar
//                }
//                .photosPicker(isPresented: $homeViewModel.presentPhotosPicker,
//                              selection: $homeViewModel.selectedPhotosPickerItem, photoLibrary: .shared())
//                .navigationDestination(for: String.self) { _ in
//                    SettingsView<SettingsViewModel, AuthManaging>(path: $homeViewModel.path)
//                }
//        }
//        .sheet(item: $homeViewModel.sheet, content: makeSheet)
////        .sheet(isPresented: $ingredientRecognitionHandler.presentNewIngredients) {
////            CardDetailView<CreateCardViewModel>(
////                viewModel: CreateCardViewModel(
////                    coreDataController: .shared,
////                    tempCard: TempIngredientCard(
////                        title: "New Card",
////                        ingredients: ingredientRecognitionHandler.lastIngredientGroupFromChatGPT!.ingredients
////                    ),
////                    context: coreDataController.newContext
////                )
////            )
////        }
//        .onChange(of: homeViewModel.selectedPhotosPickerItem) { newPhoto in
//            Task {
//                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
//                    if let uiImage = UIImage(data: data) {
//                        homeViewModel.selectedImage = uiImage
//                        homeViewModel.sheet = .imageROI
//                    }
//                }
//            }
//        }
//        .environmentObject(homeViewModel)
//        .environmentObject(recipeRecognitionHandler)
//    }
//
//    // MARK: - Subviews
//    private var mainView: some View {
//        Group {
//            if ingredientCards.isEmpty {
//                emptyIngredientCardsView
//            } else {
//                ingredientCardsView
//            }
//        }
//        .overlay {
//            if recipeRecognitionHandler.recognitionInProgress {
//                ProgressView()
//                    .tint(.white)
//                    .background {
//                        RoundedRectangle(cornerRadius: 15)
//                            .frame(width: 60, height: 60)
//                            .opacity(0.6)
//                    }
//            }
//        }
//    }
//
//    private var emptyIngredientCardsView: some View {
//        VStack {
//            Text("Tap the plus to get started! ☝️")
//                .font(.system(size: 30))
//                .fontWeight(.semibold)
//                .fontDesign(.rounded)
//                .frame(width: 300)
//                .frame(minHeight: 600)
//        }
//    }
//
//    private var ingredientCardsView: some View {
//        List {
//            ForEach(ingredientCards) { ingredientCard in
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(ingredientCard.title)
//                        .font(.system(size: 24))
//                        .fontWeight(.semibold)
//                        .fontDesign(.rounded)
//
//                    ForEach(ingredientCard.ingredientsArr) { ingredient in
//                        HStack(alignment: .center) {
//                            SwipeableIngredient(ingredient: ingredient)
//                                .font(.system(size: 17, weight: .semibold, design: .rounded))
//                        }
//                    }
//                }
//                .swipeActions {
//                    Button(role: .destructive) {
//                        do {
//                            try coreDataController.delete(ingredientCard, in: coreDataController.viewContext)
//                        } catch {
//                            print("Error deleting card: \(error.localizedDescription)")
//                        }
//                    } label: {
//                        Label("Delete", systemImage: "trash.fill")
//                    }
//
//                    Button {
//                        homeViewModel.selectedCard = ingredientCard
//                        homeViewModel.sheet = .editCard
//                    } label: {
//                        Label("Edit", systemImage: "pencil")
//                    }
//                    .tint(.orange)
//                }
//            }
//        }
//        .listRowSpacing(10)
//    }
//
//    private var mainViewToolbar: some ToolbarContent {
//        Group {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Image("grocemateLogoSmall")
//                    .imageScale(.large)
//                    .shadow(radius: 2)
//                    .drawingGroup()
//            }
//
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Menu {
//                    Button {
//                        homeViewModel.sheet = .documentScanner
//                    } label: {
//                        HStack {
//                            Text("Scan a Recipe")
//                            Image(systemName: "doc.viewfinder")
//                        }
//                    }
//
//                    Button {
//                        homeViewModel.presentPhotosPicker = true
//                    } label: {
//                        HStack {
//                            Text("Select from Photos")
//                            Image(systemName: "photo.stack")
//                        }
//                    }
//
//                    Button {
//                        homeViewModel.sheet = .manuallyCreateCard
//                    } label: {
//                        HStack {
//                            Text("Manually Add Recipe")
//                            Image(systemName: "character.cursor.ibeam")
//                        }
//                    }
//                } label: {
//                    Image(systemName: "plus")
//                        .font(.system(size: 16, weight: .semibold))
//                        .accessibilityLabel("Add a new card.")
//                }
//            }
//
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Menu {
//                    Section("Sort By") {
//                        Button {
//                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.titleAsc)
//                            }
//                        } label: {
//                            HStack {
//                                Text("Title, Ascending")
//                                Image(systemName: "character.cursor.ibeam")
//                            }
//                        }
//                        Button {
//                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.titleDesc)
//                            }
//                        } label: {
//                            HStack {
//                                Text("Title, Descending")
//                                Image(systemName: "character.cursor.ibeam")
//                            }
//                        }
//                        Button {
//                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.timestampAsc)
//                            }
//                        } label: {
//                            HStack {
//                                Text("Date, Ascending")
//                                Image(systemName: "character.cursor.ibeam")
//                            }
//                        }
//                        Button {
//                            withAnimation {
//                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.timestampDesc)
//                            }
//                        } label: {
//                            HStack {
//                                Text("Date, Descending")
//                                Image(systemName: "character.cursor.ibeam")
//                            }
//                        }
//                    }
//                } label: {
//                    Image(systemName: "arrow.up.and.down.text.horizontal")
//                        .font(.system(size: 16, weight: .semibold))
//                }
//
//            }
//
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    homeViewModel.path.append("Settings")
//                } label: {
//                    Image(systemName: "gear")
//                        .font(.system(size: 16, weight: .semibold))
//                }
//            }
//        }
//    }
//
//    @ViewBuilder private func makeSheet(_ sheet: Sheets) -> some View {
//        switch sheet {
//        case .imageROI:
//            if let image = homeViewModel.selectedImage {
//                ImageWithROI(image: image)
//            } else {
//                EmptyView()
//            }
//        case .editCard:
//            if let selectedCard = homeViewModel.selectedCard {
//                CardDetailView<EditCardViewModel>(viewModel:
//                                                    EditCardViewModel(
//                                                        coreDataController: .shared,
//                                                        ingredientCard: selectedCard
//                                                    )
//                )
//            }
//        case .manuallyCreateCard:
//            CardDetailView<CreateCardViewModel>(
//                viewModel: CreateCardViewModel(coreDataController: .shared, context: coreDataController.newContext)
//            )
//        case .documentScanner:
//            DocumentScanner { images in
//                recipeRecognitionHandler.recognizeRecipeIn(images: images)
//            }
//            .ignoresSafeArea()
//        }
//    }
//}
//
//#Preview("Main View with Data") {
//    let preview = CoreDataController.shared
//
//    let viewToPreview = {
//        HomeView<AuthenticationManager>()
//            .environmentObject(AuthenticationManager())
//            .environment(\.managedObjectContext, preview.viewContext)
//            .onAppear {
//                IngredientCard.makePreview(count: 2, in: preview.viewContext)
//            }
//    }()
//
//    return viewToPreview
//}
//
//#Preview("Empty Main View") {
//    let preview = CoreDataController.shared
//
//    let viewToPreview = {
//        HomeView<AuthenticationManager>()
//            .environmentObject(AuthenticationManager())
//            .environment(\.managedObjectContext, preview.viewContext)
//            .onAppear {
//                IngredientCard.makePreview(count: 0, in: preview.viewContext)
//            }
//    }()
//
//    return viewToPreview
//}
