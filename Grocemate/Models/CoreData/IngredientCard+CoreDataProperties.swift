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

extension IngredientCard : Identifiable {

}
