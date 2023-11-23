//
//  Ingredient+CoreDataProperties.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/8/23.
//

import CoreData
import Foundation

// MARK: - Fetch Requests
extension Ingredient {
    private static var ingredientsFetchRequest: NSFetchRequest<Ingredient> {
        NSFetchRequest(entityName: "Ingredient")
    }

    static func ingredientsForCard(_ selectedIngredientCard: IngredientCard) -> NSFetchRequest<Ingredient> {
        let request: NSFetchRequest<Ingredient> = ingredientsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: false)
        ]
        request.predicate = NSPredicate(format: "ingredientCard == %@", selectedIngredientCard)

        return request
    }
}

// MARK: - Previews
extension Ingredient {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Ingredient] {
        var ingredients = [Ingredient]()

        for _ in 0..<count {
            let ingredient = Ingredient(context: context)
            ingredient.name = "e.g. 1 cup (250ml) whole milk"

            ingredients.append(ingredient)
        }

        return ingredients
    }

    static func preview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> Ingredient {
        return makePreview(count: 1, in: context)[0]
    }

    static func emptyPreview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> Ingredient {
        return Ingredient(context: context)
    }
}
