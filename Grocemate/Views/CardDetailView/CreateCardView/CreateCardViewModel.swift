//
//  CreateCardViewModel.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import CoreData
import Foundation
import SwiftUI

final class CreateCardViewModel: ObservableObject, CardDetailViewModellable {
    // MARK: - Properties
    @Published var editMode: EditMode = .active
    @Published var titleError: Bool = false
    @Published var ingredientsError: Bool = false

    /// Create a Published temporary instance of an ingredient card
    /// to use in our view. Also use a Published array of Ingredient
    /// instances and then we will add them to the temporary
    /// IngredientCard before saving.
    @Published var card: IngredientCard
    @Published var ingredients: [Ingredient]

    /// We use a new context as a temporary editing board outside
    /// the main view context.
    private let context: NSManagedObjectContext

    init(coreDataController: CoreDataController) {
        self.context = coreDataController.newContext
        self.card = IngredientCard(context: self.context)
        self.ingredients = [
            Ingredient.preview(context: self.context)
        ]
    }

    public func addIngredient() {
        self.ingredients.append(Ingredient(context: self.context))
    }

    /// Using a separate array of Ingredients allows us to circumvent problems with NSSet
    /// in the CoreDataClass for Ingredient.
    public func addIngredientsToCard() {
        card.addToIngredients(NSSet(array: ingredients))
    }

    public func clearCardTitle() {
        card.title = ""
    }

    public func deleteIngredient(_ indexSet: IndexSet) {
        ingredients.remove(atOffsets: indexSet)
    }

    public func save() throws {
        /// Make sure title isn't blank.
        guard self.card.title.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            withAnimation(.easeInOut(duration: 0.5)) {
                titleError = true
            }

            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                titleError = false
            }

            return
        }

        /// Check is ingredients is not empty.
        guard !self.ingredients.isEmpty else {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.ingredientsError = true
                self.ingredients.append(Ingredient.preview(context: self.context))
            }

            /// Doesn't work right.
            withAnimation(.easeIn(duration: 2.0).delay(2.0)) {
                self.ingredientsError = false
            }

            return
        }

        do {
            try saveToCoreData()
        } catch {
            print("An error occurred saving the card: \(error.localizedDescription)")
        }
    }

    public func saveToCoreData() throws {
        guard self.context.hasChanges else { return }

        try self.context.save()
        print("Saved")
    }
}
