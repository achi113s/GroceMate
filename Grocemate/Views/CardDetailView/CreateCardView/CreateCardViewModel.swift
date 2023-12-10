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

    /// Use the ingredient card in our view.
    /// Also use a Published reference of the ingredients associated
    /// with the card. This allows us to use and modify these rather than
    /// mess with the NSManagedObject. On save, we replace the ingredients
    /// Set and title with what we have in the Published properties.
    var card: IngredientCard
    @Published var title: String
    @Published var ingredients: [Ingredient]

    private let context: NSManagedObjectContext

    /// Initialize from "Manually Add Card"
    init(coreDataController: CoreDataController) {
        /// We will use a new context as a temporary editing board outside
        /// the main view context.
        self.context = coreDataController.newContext
        self.card = IngredientCard(context: coreDataController.newContext)
        self.title = "New Card"
        self.ingredients = [
            Ingredient.preview(context: coreDataController.newContext)
        ]
    }

    /// Initialize from Vision/ChatGPT parse.
    init(coreDataController: CoreDataController,
         tempCard: TempIngredientCard
    ) {
        /// We will use a new context as a temporary editing board outside
        /// the main view context.
        self.context = coreDataController.newContext
        self.card = IngredientCard(context: coreDataController.newContext)
        self.title = tempCard.title
        self.ingredients = tempCard.ingredients.map({ ingredientName in
            let newIngredient = Ingredient(context: coreDataController.newContext)
            newIngredient.name = ingredientName
            return newIngredient
        })
    }

    public func addDummyIngredient() {
        self.ingredients.append(Ingredient(context: self.context))
    }

    /// Using a separate array of Ingredients allows us to circumvent problems with NSSet
    /// in the CoreDataClass for Ingredient. This method replaces the NSManagedObject's
    /// ingredients Set with what we have in this view model.
    public func setIngredientsToCard() {
        self.card.ingredients = Set(self.ingredients)
    }

    public func setCardTitle() {
        card.title = self.title
    }

    public func clearTitle() {
        self.title = ""
    }

    public func deleteIngredient(_ indexSet: IndexSet) {
        ingredients.remove(atOffsets: indexSet)
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

        setCardTitle()
        setIngredientsToCard()

        do {
            try CoreDataController.shared.persist(in: context)
        } catch {
            print("An error occurred saving the card: \(error.localizedDescription)")
        }
    }

    public func titleErrorAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.titleError = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.titleError = false
            }
        }
    }

    public func ingredientsErrorAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            self.ingredientsError = true
            self.ingredients.append(Ingredient.preview(context: self.context))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.ingredientsError = false
                print("false")
            }
        }
    }
}
