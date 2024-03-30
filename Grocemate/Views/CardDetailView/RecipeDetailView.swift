//
//  CreateCardView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import SwiftUI

struct RecipeDetailView<ViewModel: RecipeDetailViewModelling>: View {
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss

    // MARK: - State
    @StateObject var viewModel: ViewModel
    @FocusState var titleFocused: Bool
    @State var titleRowError: Bool = false

    var body: some View {
        NavigationStack {
            ingredientList
                .toolbar {
                    toolbarView
                }
                .environment(\.editMode, $viewModel.editMode)
                .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Subviews
    private var addButton: some View {
        Button {
            withAnimation {
                viewModel.addDummyIngredient()
            }
        } label: {
            Text("Add Ingredient")
                .font(.title3)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding()
        }
        .buttonStyle(.polished)
    }

    private var ingredientCardTitle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(viewModel.titleError ? .red.opacity(0.2) : .blue.opacity(0.1))
                .frame(height: 60)
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                TextField("Recipe Title", text: $viewModel.title)
                    .disabled(viewModel.editMode == .inactive)
                    .font(.system(.title3))
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .padding()
                    .focused($titleFocused)
                /// .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
                /// Causes:
                /// "Error: this application, or a library it uses, has passed an invalid
                /// numeric value (NaN, or not-a-number) to CoreGraphics API and this
                /// value is being ignored. Please fix this problem."
                /// A clear text field button is not available without reaching into UITextField.
                /// Add a custom button.
                    .overlay {
                        if titleFocused {
                            HStack {
                                Spacer()

                                Button {
                                    viewModel.clearTitle()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title2)
                                        .tint(.gray.opacity(0.5))
                                }
                                .padding(.trailing, 20)
                            }
                        }
                    }
            }
        }
    }

    private var ingredientList: some View {
        List {
            Section("") {
                TextField("Recipe Title", text: $viewModel.title)
                    .disabled(viewModel.editMode == .inactive)
                    .font(.system(.title2))
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .listRowBackground(Color(
                        viewModel.titleError ? UIColor.systemRed.withAlphaComponent(0.2) :
                            UIColor.systemGray.withAlphaComponent(0.1)).animation(.easeInOut(duration: 0.5))
                    )
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }

                TextField("Yield", text: $viewModel.yield)
                    .disabled(viewModel.editMode == .inactive)
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                    .padding(.vertical, 5)
                    .listRowBackground(Color(UIColor.systemGray.withAlphaComponent(0.1)))
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
            }

            Section(header: Text("Ingredients")) {
                ForEach($viewModel.ingredients) { $ingredient in
                    TextField("e.g. 1 tsp vanilla", text: $ingredient.name, axis: .vertical)
                        .disabled(viewModel.editMode == .inactive)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                .onDelete(perform: viewModel.deleteIngredient)
                .listRowBackground(Color(
                    viewModel.ingredientsError ? UIColor.systemRed.withAlphaComponent(0.2) :
                        UIColor.systemGray.withAlphaComponent(0.1)).animation(.easeInOut(duration: 0.5))
                )

                AddListElementButton {
                    withAnimation {
                        viewModel.addDummyIngredient()
                    }
                }
            }

            Section(header: Text("Steps")) {
                ForEach($viewModel.steps) { $step in
                    TextField("e.g. Preheat the oven to 400˚F.", text: $step.stepText, axis: .vertical)
                        .disabled(viewModel.editMode == .inactive)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                .onDelete(perform: viewModel.deleteRecipeStep)
                .onMove { indices, newOffset in
                    viewModel.moveRecipeStep(from: indices, to: newOffset)
                }
                .listRowBackground(Color(
                    viewModel.ingredientsError ? UIColor.systemRed.withAlphaComponent(0.2) :
                        UIColor.systemGray.withAlphaComponent(0.1)).animation(.easeInOut(duration: 0.5))
                )

                AddListElementButton {
                    withAnimation {
                        viewModel.addDummyStep()
                    }
                }
            }

            Section(header: Text("Notes")) {
                TextField("Recipe Notes", text: $viewModel.notes)
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                    .listRowBackground(Color(
                        UIColor.systemGray.withAlphaComponent(0.1)).animation(.easeInOut(duration: 0.5)))
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
                        try viewModel.save()
                        dismiss()
                    } catch CardDetailSaveError.titleError {
                        titleErrorAnimation()
                    } catch CardDetailSaveError.ingredientsError {
                        ingredientsErrorAnimation()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Save")
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func titleErrorAnimation() {
        viewModel.titleError = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            viewModel.titleError = false
        }
    }

    private func ingredientsErrorAnimation() {
        viewModel.ingredientsError = true
        viewModel.addDummyIngredient()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            viewModel.ingredientsError = false
        }
    }

    private struct AddListElementButton: View {
        let action: () -> Void

        var body: some View {
            Button(action: {}) {
                Button {
                    action()
                } label: {
                    Text("Add New")
                        .font(.body)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, minHeight: 30)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle(radius: 0))
            }
            .buttonStyle(.plain)
            .listRowBackground(EmptyView())
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .tint(.blue)
        }
    }
}

#Preview("RecipeDetailView_ManualAdd") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        RecipeDetailView<CreateRecipeViewModel>(
            viewModel: CreateRecipeViewModel(
                context: preview.newContext
            )
        )
        .environment(\.managedObjectContext, preview.viewContext)
    }()

    return viewToPreview
}

#Preview("RecipeDetailView_EditRecipe") {
    let preview = CoreDataController.shared

    let viewToPreview = {
        RecipeDetailView<EditRecipeViewModel>(
            viewModel: EditRecipeViewModel(coreDataController: preview, recipe: Recipe.preview())
        )
        .environment(\.managedObjectContext, preview.viewContext)
    }()

    return viewToPreview
}
