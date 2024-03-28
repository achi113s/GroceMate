//
//  EditCardViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import CoreData
import Foundation
import SwiftUI

final class EditRecipeViewModel: ObservableObject, RecipeDetailViewModelling {
    // MARK: - Properties
    @Published var editMode: EditMode = .active
    @Published var titleError: Bool = false
    @Published var ingredientsError: Bool = false

    /// Use the recipe in our view.
    /// Also use a Published reference of the ingredients associated
    /// with the recipe. This allows us to use and modify these rather than
    /// mess with the NSManagedObject. On save, we fill in the
    /// properties of the Recipe object.
    var recipe: Recipe
    @Published var title: String
    @Published var yield: String
    @Published var ingredients: [Ingredient]
    @Published var steps: [RecipeStep]
    @Published var notes: String

    private let context: NSManagedObjectContext

    init(coreDataController: CoreDataController,
         recipe: Recipe
    ) {
        /// When editing a recipe, that card will exist in the main view content,
        /// not the newContext we defined in CoreDataController. Hence, we have to use
        /// viewContext.
        self.context = coreDataController.viewContext
        self.recipe = recipe
        self.title = recipe.title
        self.yield = recipe.yield
        self.ingredients = recipe.ingredientsArr
        self.steps = recipe.recipeStepsArr
        self.notes = recipe.notes

        print("init editcardviewmodel")
    }

    public func addDummyIngredient() {
        self.ingredients.append(Ingredient(context: self.context))
    }

    public func addDummyStep() {
        var newStep = RecipeStep(context: self.context)
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
        ingredients.remove(atOffsets: indexSet)
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
            try CoreDataController.shared.persist(in: context)
        } catch {
            print("An error occurred saving the card: \(error.localizedDescription)")
        }
    }
}
