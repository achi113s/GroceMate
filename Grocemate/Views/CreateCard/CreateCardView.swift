//
//  CreateCardView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import SwiftUI

struct CreateCardView: View {
    //MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    //MARK: - State
    @ObservedObject var vm: CreateCardViewModel
    
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
                .environment(\.editMode, $vm.editMode)
                .scrollContentBackground(.hidden)
                //                .toolbarBackground(Color("ToolbarBackground"), for: .automatic)
            }
            
        }
    }
    
    init(vm: CreateCardViewModel) {
        self.vm = vm
    }
    
    //MARK: - Subviews
    private var addButton: some View {
        Button {
            withAnimation {
                vm.addIngredient()
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
                .fill(.blue.opacity(0.1))
                .frame(height: 60)
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                TextField("Recipe Title", text: $vm.tempCard.title)
                    .disabled(vm.editMode == .inactive)
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
                ForEach($vm.tempIngredients) { $ingredient in
                    TextField("Ingredient", text: $ingredient.name, axis: .vertical)
                        .disabled(vm.editMode == .inactive)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                }
                .onDelete(perform: vm.deleteIngredient)
                .listRowBackground(Color.gray.opacity(0.1))
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
                        vm.addIngredientsToCard()
                        try vm.save()
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
        CreateCardView(vm: .init(coreDataController: .shared))
            .environment(\.managedObjectContext, preview.viewContext)
    }()
    
    return viewToPreview
}
