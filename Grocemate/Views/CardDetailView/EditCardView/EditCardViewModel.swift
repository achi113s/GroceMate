//
//  EditCardViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import CoreData
import Foundation
import SwiftUI

final class EditCardViewModel: ObservableObject, CardDetailViewModellable {
    // MARK: - Properties
    @Published var editMode: EditMode = .active
    @Published var titleError: Bool = false
    @Published var ingredientsError: Bool = false

    /// Use a Published reference of the ingredient card in our view.
    /// Also use a Published reference of the ingredients associated
    /// with the card. This allows us to use an array rather than an
    /// NSSet. On save, we replace the ingredients Set with what we
    /// have in the Published reference.
    @Published var card: IngredientCard
    @Published var ingredients: [Ingredient]

    private let context: NSManagedObjectContext

    init(coreDataController: CoreDataController, ingredientCard: IngredientCard) {
        self.context = coreDataController.viewContext
        self.card = ingredientCard
        self.ingredients = ingredientCard.ingredientsArr
    }

    public func addIngredient() {
        self.ingredients.append(Ingredient(context: self.context))
    }

    /// Using a separate array of Ingredients allows us to circumvent problems with NSSet
    /// in the CoreDataClass for Ingredient.
    public func addIngredientsToCard() {
        card.ingredients = Set(ingredients)
    }

    public func clearCardTitle() {
        card.title = ""
    }

    public func deleteIngredient(_ indexSet: IndexSet) {
        ingredients.remove(atOffsets: indexSet)
    }

    public func save() throws {
        /// Make sure title field isn't blank.
        guard self.card.title.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            withAnimation(.easeInOut(duration: 0.5)) {
                titleError = true
            }

            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                titleError = false
            }

            return
        }

        /// Make sure ingredients list isn't empty.
        guard !self.ingredients.isEmpty else {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.ingredientsError = true
                self.ingredients.append(Ingredient.preview(context: self.context))
            }

            /// This one doesn't work as expected?
            withAnimation(.easeIn(duration: 2.0).delay(2.0)) {
                self.ingredientsError = false
            }

            return
        }

        do {
            try CoreDataController.shared.persist(in: context)
        } catch {
            print("An error occurred saving the card: \(error.localizedDescription)")
        }
    }
}
