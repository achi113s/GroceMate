//
//  ContentView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import PhotosUI
import SwiftUI

struct HomeView: View {
    // MARK: - State
    @StateObject var homeViewModel = HomeViewModel(coreDataController: CoreDataController.shared)
    @StateObject var ingredientRecognitionHandler: IngredientRecognitionHandler = IngredientRecognitionHandler(openAIManager: OpenAIManager())

    // MARK: - Properties
    @FetchRequest(fetchRequest: IngredientCard.all()) private var ingredientCards
    var coreDataController = CoreDataController.shared

    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            mainView
                .toolbar {
                    mainViewToolbar
                }
                .photosPicker(isPresented: $homeViewModel.presentPhotosPicker,
                              selection: $homeViewModel.selectedPhotosPickerItem, photoLibrary: .shared())
        }
        .sheet(item: $homeViewModel.sheet, content: makeSheet)
        .confirmationDialog("Card Options", isPresented: $homeViewModel.presentConfirmationDialog) {
            Button {
                homeViewModel.sheet = .editCard
            } label: {
                Text("Edit Card")
            }

            Button(role: .destructive) {
                homeViewModel.deleteAlert = true
            } label: {
                Text("Delete")
            }
        }
        .alert("Delete Card", isPresented: $homeViewModel.deleteAlert) {
            Button(role: .cancel) {

            } label: {
                Text("Cancel")
            }

            Button {
                guard let selectedCard = homeViewModel.selectedCard else { return }

                do {
                    try coreDataController.delete(selectedCard, in: coreDataController.viewContext)
                } catch {
                    print("Error deleting card: \(error.localizedDescription)")
                }
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete this card?")
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
        .environmentObject(homeViewModel)
        .environmentObject(ingredientRecognitionHandler)
    }

    // MARK: - Subviews
    private var mainView: some View {
        ScrollView(.vertical) {
            VStack {
                if ingredientCards.isEmpty {
                    emptyIngredientCardsView
                } else {
                    ingredientCardsView
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                }
            }
        }
        //        .searchable(text: $homeViewModel.query, placement: .toolbar)
        //        .onChange(of: homeViewModel.query) { _ in
        //            ingredientCards.nsPredicate = IngredientCard.filter(homeViewModel.query)
        //        }
    }

    private var emptyIngredientCardsView: some View {
        Text("Tap the plus to get started! ☝️")
            .font(.system(size: 30))
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .frame(width: 300)
            .frame(minHeight: 600)
    }

    private var ingredientCardsView: some View {
        LazyVStack(alignment: .center) {
            ForEach(ingredientCards) { ingredientCard in
                Card(ingredientCard: ingredientCard)
                    .padding(.bottom, 15)
            }
        }
    }

    private var mainViewToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Grocemate")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(.blue)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        homeViewModel.sheet = .cameraView
                    } label: {
                        HStack {
                            Text("Take a Picture")
                            Image(systemName: "camera")
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
                            Text("Manually Add Card")
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
                                ingredientCards.nsSortDescriptors = IngredientCard.sortBy(.timestampAsc)
                            }
                        } label: {
                            HStack {
                                Text("Date, Ascending")
                                Image(systemName: "character.cursor.ibeam")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.and.down.text.horizontal")
                        .font(.system(size: 16, weight: .semibold))
                }

            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    homeViewModel.path.append("Settings")
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    //    private var showCreateCardViewButton: some View {
    //        Button {
    //            showCreateCardView = true
    //        } label: {
    //            ZStack {
    //                RoundedRectangle(cornerRadius: 15)
    //                    .foregroundStyle(.blue)
    //                    .frame(width: 120, height: 50)
    //                Text("Grocemate")
    //                    .fontWeight(.bold)
    //                    .fontDesign(.rounded)
    //            }
    //        }
    //        .tint(.white)
    //    }

    @ViewBuilder private func makeSheet(_ sheet: Sheets) -> some View {
        switch sheet {
        case .cameraView:
            EmptyView()
            //            CameraView()
        case .imageROI:
            if let image = homeViewModel.selectedImage {
                ImageWithROI(image: image)
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
        }
    }
}

#Preview("Main View with Data") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        HomeView()
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
        HomeView()
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                IngredientCard.makePreview(count: 0, in: preview.viewContext)
            }
    }()

    return viewToPreview
}
