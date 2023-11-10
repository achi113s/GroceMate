//
//  CreateCardViewModel.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import CoreData
import Foundation
import SwiftUI

final class CreateCardViewModel: ObservableObject {
    /// Create a Published temporary instance of an ingredient card
    /// to use in our view.
    @Published var tempCard: IngredientCard
    @Published var tempIngredients: [Ingredient]
    @Published var editMode: EditMode = .active
    
    /// Use a new context as a temporary editing board outside
    /// the main view context.
    private let context: NSManagedObjectContext
    
    init(coreDataController: CoreDataController) {
        self.context = coreDataController.newContext
        self.tempCard = IngredientCard(context: self.context)
        self.tempIngredients = [
            Ingredient.preview(context: self.context)
        ]
    }
    
    public func addIngredient() {
        tempIngredients.append(Ingredient(context: self.context))
    }
    
    public func addIngredientsToCard() {
        tempCard.addToIngredients(NSSet(array: tempIngredients))
    }
    
    public func clearCardTitle() {
        tempCard.title = ""
    }
    
    public func deleteIngredient(_ indexSet: IndexSet) {
        tempIngredients.remove(atOffsets: indexSet)
    }
    
    public func save() throws {
        guard self.context.hasChanges else { return }
        
        try self.context.save()
        print("Saved")
    }
}
