//
//  CreateCardView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import SwiftUI

struct CardDetailView<ViewModel: CardDetailViewModellable>: View {
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss

    // MARK: - State
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ingredientCardTitle
                    .padding(20)
                List {
                    ingredientList
                }
                .toolbar {
                    toolbarView
                }
                .environment(\.editMode, $viewModel.editMode)
                .scrollContentBackground(.hidden)
            }
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Subviews
    private var addButton: some View {
        Button {
            withAnimation {
                viewModel.addIngredient()
            }
        } label: {
            Text("Add Ingredient")
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.blue)
                }
        }
        .tint(.white)
    }

    private var ingredientCardTitle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(viewModel.titleError ? .red.opacity(0.2) : .blue.opacity(0.1))
                .frame(height: 60)
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                TextField("Recipe Title", text: $viewModel.card.title)
                    .disabled(viewModel.editMode == .inactive)
                    /// This adds the x to clear text field when editing.
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
                    .font(.system(.title3))
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .padding()
            }
        }
    }

    private var ingredientList: some View {
        Group {
            Section(header: Text("Ingredients")) {
                ForEach($viewModel.ingredients) { $ingredient in
                    TextField("Ingredient", text: $ingredient.name, axis: .vertical)
                        .disabled(viewModel.editMode == .inactive)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                .onDelete(perform: viewModel.deleteIngredient)
                .listRowBackground(viewModel.ingredientsError ? Color.red.opacity(0.2) : .gray.opacity(0.1))
            }

            Section {
                EmptyView()
            } footer: {
                HStack(alignment: .center) {
                    Spacer()
                    addButton
                    Spacer()
                }
            }
        }
    }

    private var toolbarView: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    do {
                        viewModel.addIngredientsToCard()
                        try viewModel.save()
                    } catch {
                        print("error")
                    }

                    dismiss()
                } label: {
                    Text("Save")
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    let preview = CoreDataController.shared

    let viewToPreview = {
        CardDetailView<CreateCardViewModel>(viewModel: CreateCardViewModel(coreDataController: .shared))
            .environment(\.managedObjectContext, preview.viewContext)
    }()

    return viewToPreview
}
