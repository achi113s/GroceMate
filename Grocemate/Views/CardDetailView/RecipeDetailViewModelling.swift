//
//  CardDetailViewModelProtocol.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import SwiftUI

protocol RecipeDetailViewModelling: ObservableObject {
    var editMode: EditMode { get set }
    var titleError: Bool { get set }
    var ingredientsError: Bool { get set }

    var recipe: Recipe { get set }
    var title: String { get set }
    var ingredients: [Ingredient] { get set }
    var steps: [RecipeStep] { get set }
    var notes: String { get set }
    var yield: String { get set }

    func clearTitle()
    func addDummyIngredient()
    
    func setRecipeTitle()
    func setIngredientsToRecipe()
    func setStepsToRecipe()
    func setRecipeNotes()
    func setRecipeYield()

    func deleteIngredient(_ indexSet: IndexSet)
    func save() throws
}
