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
            ZStack(alignment: .top) {
                List {
                    Section {
                        TextField("Recipe Title", text: $vm.tempCard.title)
                            .disabled(vm.editMode == .inactive)
                            .font(.system(.title3))
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .padding()
                    }
                    
                    //                    Section {
                    //                        ForEach($vm.tempCard.ingredients, id: \.hashValue) { $ingredient in
                    //                            TextField("Ingredient", text: $ingredient, axis: .vertical)
                    //                                .disabled(vm.editMode == .inactive)
                    //                                .fontDesign(.rounded)
                    //                                .fontWeight(.semibold)
                    //                        }
                    ////                        .onDelete(perform: onDelete)
                    //                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            do {
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
                .environment(\.editMode, $vm.editMode)
                .scrollContentBackground(.hidden)
                //                .toolbarBackground(Color("ToolbarBackground"), for: .automatic)
            }
        }
    }
    
    //    init(ingredientCard: IngredientCard) {
    //        let ingredientsList = ingredientCard.ingredientsArray.compactMap({ ingredient in
    //            return ingredient.ingredient
    //        })
    //
    //        self._ingredients = State(initialValue: ingredientsList)
    //        self._title = State(initialValue: ingredientCard.title ?? "")
    //
    //        self.editMode = .active
    //    }
    //
    //    init(decodedIngredients: DecodedIngredients?) {
    //        self._ingredients = State(initialValue: decodedIngredients?.ingredients ?? [])
    //        self._title = State(initialValue: "New Ingredients")
    //
    //        self.editMode = .active
    //    }
    
    init(vm: CreateCardViewModel) {
        self.vm = vm
    }
}

//#Preview {
//    EditIngredientCardView(ingredientCard: IngredientCard(name: "Green Tea Ice Cream",
//                                                      ingredients: [
//                                                        Ingredient("1 cup (250ml) whole milk"),
//                                                        Ingredient("3/4 cup (150g) sugar"),
//                                                        Ingredient("pinch of kosher or sea salt"),
//                                                        Ingredient("2 cups (500ml) heavy cream"),
//                                                        Ingredient("4 teaspoons matche (green tea powder)"),
//                                                        Ingredient("6 large egg yolks"),
//                                                      ]))
//}
//
#Preview {
    CreateCardView(vm: .init(coreDataController: .shared))
}

//    NewIngredientsView(ingredients: [
//        "½ cup heavy cream",
//        "10 ounces fresh unsalted fatback or lean salt pork, cut into small dice",
//        "About 1 quart water",
//        "1 cup diced carrot (⅛- to ¼-inch dice)",
//        "⅔ cup diced celery (same dimensions)",
//        "½ cup diced onion (same dimensions)",
//        "1¼ pounds beef skirt steak or boneless chuck blade roast, coarsely ground",
//        "½ cup dry Italian white wine, preferably Trebbiano or Albana",
//        "2 tablespoons double or triple-concentrated imported Italian tomato paste, diluted in 10 tablespoons Poultry/ Meat Stock (page 66) or Quick Stock (page 68)",
//        "1 cup whole milk",
//        "Salt and freshly ground black pepper to taste"
//    ])
