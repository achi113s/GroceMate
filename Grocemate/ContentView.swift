//
//  ContentView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    //MARK: - State
    @State private var showCreateCardView: Bool = false
    
    //MARK: - Properties
    @FetchRequest(fetchRequest: IngredientCard.all()) private var ingredientCards
    var coreDataController = CoreDataController.shared
    
    var body: some View {
        NavigationStack {
            mainView
            .toolbar {
                mainViewToolbar
            }
        }
        .sheet(isPresented: $showCreateCardView, content: {
            CreateCardView(vm: .init(coreDataController: .shared))
        })
    }
    
    private var mainView: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    if ingredientCards.isEmpty {
                        nullIngredientCardsView
                    } else {
                        ingredientCardsView
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .refreshable {
                print("refresh")
            }
            
            Button {
                showCreateCardView = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: 50)
                    Text("Grocemate")
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
            }
            .tint(.white)
        }
    }
    
    private var nullIngredientCardsView: some View {
        Text("Tap the camera icon to get started!")
            .font(.system(size: 30, weight: .semibold, design: .rounded))
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
                //                            .foregroundColor(Color("AccentColor"))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        //                            mainViewModel.sheet = .cameraView
                    } label: {
                        HStack {
                            Text("Take a Picture")
                            Image(systemName: "camera")
                        }
                    }
                    
                    Button {
                        //                            mainViewModel.presentPhotosPicker = true
                    } label: {
                        HStack {
                            Text("Select from Photos")
                            Image(systemName: "photo.stack")
                        }
                    }
                } label: {
                    Image(systemName: "camera.on.rectangle")
                        .font(.system(size: 16, weight: .semibold))
                    //                                .foregroundColor(Color("AccentColor"))
                        .accessibilityLabel("Get an picture of ingredients")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //                        mainViewModel.path.append("Settings")
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .semibold))
                    //                                .foregroundColor(Color("AccentColor"))
                }
            }
        }
    }
}

#Preview("Main View with Data") {
    let preview = CoreDataController.shared
    
    let viewToPreview = {
        ContentView()
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
        ContentView()
            .environment(\.managedObjectContext, preview.viewContext)
            .onAppear {
                IngredientCard.makePreview(count: 0, in: preview.viewContext)
            }
    }()
    
    return viewToPreview
}
