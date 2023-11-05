//
//  IngredientCard+CoreDataProperties.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//
//

import Foundation
import CoreData

//MARK: - Fetch Requests
extension IngredientCard {
    private static var ingredientCardsFetchRequest: NSFetchRequest<IngredientCard> {
        NSFetchRequest(entityName: "IngredientCard")
    }
    
    /// Fetch all ingredient cards in descending order by creation date.
    static func all() -> NSFetchRequest<IngredientCard> {
        let request: NSFetchRequest<IngredientCard> = ingredientCardsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        return request
    }
}

// MARK: Generated accessors for ingredients
extension IngredientCard {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

//MARK: - Previews
extension IngredientCard {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [IngredientCard] {
        var cards = [IngredientCard]()
        
        for _ in 0..<count {
            let ingredientCard = IngredientCard(context: context)
            ingredientCard.title = "Green Tea Ice Cream"
            
            let ingredient1 = Ingredient(context: context)
            ingredient1.ingredientCard = ingredientCard
            ingredient1.name = "1 cup (250ml) whole milk"
            
            ingredientCard.ingredients = Set([ingredient1])
            
            cards.append(ingredientCard)
        }
        
        return cards
    }
    
    static func preview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> IngredientCard {
        return makePreview(count: 1, in: context)[0]
    }
    
    static func emptyPreview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> IngredientCard {
        return IngredientCard(context: context)
    }
}
