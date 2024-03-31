//
//  CreateCardViewModel.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import CoreData
import Foundation
import SwiftUI

@MainActor final class CreateRecipeViewModel: ObservableObject, RecipeDetailViewModelling {
    // MARK: - Properties
    @Published var editMode: EditMode = .active
    @Published var titleError: Bool = false
    @Published var ingredientsError: Bool = false

    /// Use the ingredient card in our view.
    /// Also use a Published reference of the ingredients associated
    /// with the card. This allows us to use and modify these rather than
    /// mess with the NSManagedObject. On save, we replace the ingredients
    /// Set and title with what we have in the Published properties.
    var recipe: Recipe
    @Published var title: String
    @Published var yield: String
    @Published var ingredients: [Ingredient]
    @Published var steps: [RecipeStep]
    @Published var notes: String
    private let context: NSManagedObjectContext

    /// Initialize from "Manually Add Card"
    init(context: NSManagedObjectContext) {
        /// We will use a new context as a temporary editing board outside
        /// the main view context.
        self.context = context
        self.recipe = Recipe(context: context)
        self.title = "New Recipe"
        self.yield = ""
        self.ingredients = [Ingredient]()
        self.steps = [RecipeStep]()
        self.notes = ""
    }

    /// Initialize from Vision/ChatGPT parse.
    init(decodedRecipe: DecodedRecipe,
         context: NSManagedObjectContext
    ) {
        self.context = context
        self.recipe = Recipe(context: context)
        self.title = decodedRecipe.title
        self.ingredients = decodedRecipe.ingredients.map({ ingredientName in
            let newIngredient = Ingredient(context: context)
            newIngredient.name = ingredientName
            return newIngredient
        })
        self.yield = decodedRecipe.yield
        self.steps = decodedRecipe.steps.enumerated().map { (index, step) in
            let recipeStep = RecipeStep(context: context)
            recipeStep.stepText = step
            recipeStep.stepNumber = Int16(index + 1)
            return recipeStep
        }
        self.notes = decodedRecipe.notes
    }

    public func addDummyIngredient() {
        self.ingredients.append(Ingredient(context: self.context))
    }

    public func addDummyStep() {
        let newStep = RecipeStep(context: self.context)
        newStep.stepNumber = Int16(self.steps.count)
        self.steps.append(newStep)
    }

    /// Using a separate array of Ingredients allows us to circumvent problems with NSSet
    /// in the CoreDataClass for Ingredient. This method replaces the NSManagedObject's
    /// ingredients Set with what we have in this view model.
    public func setIngredientsToRecipe() {
        self.recipe.ingredients = Set(self.ingredients)
    }

    public func setRecipeTitle() {
        self.recipe.title = self.title
    }

    public func setStepsToRecipe() {
        self.recipe.recipeSteps = Set(self.steps)
    }

    public func setRecipeNotes() {
        self.recipe.notes = self.notes
    }

    public func setRecipeYield() {
        self.recipe.yield = self.yield
    }

    public func clearTitle() {
        self.title = ""
    }

    public func deleteIngredient(_ indexSet: IndexSet) {
        self.ingredients.remove(atOffsets: indexSet)
    }

    public func deleteRecipeStep(_ indexSet: IndexSet) {
        self.steps.remove(atOffsets: indexSet)
    }

    public func moveRecipeStep(from indices: IndexSet, to newOffset: Int) {
        self.steps.move(fromOffsets: indices, toOffset: newOffset)
        for (index, step) in self.steps.enumerated() {
            step.stepNumber = Int16(index + 1)
        }
    }

    public func save() throws {
        /// Make sure title field isn't blank.
        if self.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CardDetailSaveError.titleError
        }

        /// Make sure ingredients list isn't empty and that the ingredients don't have empty names.
        if self.ingredients.isEmpty || self.ingredients.map({ $0.name }).areThereEmptyStrings() {
            throw CardDetailSaveError.ingredientsError
        }

        setRecipeTitle()
        setRecipeYield()
        setIngredientsToRecipe()
        setStepsToRecipe()
        setRecipeNotes()

        do {
            try CoreDataController.shared.persist(in: self.context)
        } catch {
            print("An error occurred saving the card: \(error.localizedDescription)")
        }
    }
}
