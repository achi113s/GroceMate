//
//  EditCardViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import CoreData
import Foundation
import SwiftUI

final class EditCardViewModel: ObservableObject, CardDetailViewModel {
    //MARK: - Properties
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
        card.addToIngredients(NSSet(array: ingredients))
    }
    
    public func clearCardTitle() {
        card.title = ""
    }
    
    // This doesn't work.
    public func deleteIngredient(_ indexSet: IndexSet) {
        ingredients.remove(atOffsets: indexSet)
    }
    
    public func save() throws {
        guard self.card.title.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            withAnimation(.easeInOut(duration: 0.5)) {
                titleError = true
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                titleError = false
            }
            
            return
        }
        
        guard !self.ingredients.isEmpty else {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.ingredientsError = true
                self.ingredients.append(Ingredient.preview(context: self.context))
            }
            
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
