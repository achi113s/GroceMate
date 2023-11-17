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
    //MARK: - Properties
    @Published var editMode: EditMode = .active
    @Published var titleError: Bool = false
    @Published var ingredientsError: Bool = false
    
    /// Create a Published temporary instance of an ingredient card
    /// to use in our view. Also use a Published array of Ingredient
    /// instances and then we will add them to the temporary
    /// IngredientCard before saving.
    @Published var tempCard: IngredientCard
    @Published var tempIngredients: [Ingredient]
        
    /// We use a new context as a temporary editing board outside
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
    
    /// Using a separate array of Ingredients allows us to circumvent problems with NSSet
    /// in the CoreDataClass for Ingredient.
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
        guard self.tempCard.title.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            withAnimation(.easeInOut(duration: 0.5)) {
                titleError = true
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                titleError = false
            }
            
            return
        }
        
        guard self.tempIngredients.isEmpty else {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.ingredientsError = true
                print("asdf")
//                self.tempIngredients.append(Ingredient.preview(context: self.context))
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                ingredientsError = false
                print("asdff")
            }
            
            return
        }
    }
    
    public func saveToCoreData() throws {
        guard self.context.hasChanges else { return }
        
        try self.context.save()
        print("Saved")
    }
}
