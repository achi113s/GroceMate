//
//  IngredientCard+CoreDataProperties.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//
//

import Foundation
import CoreData

// MARK: - Fetch Requests
extension IngredientCard {
    private static var ingredientCardsFetchRequest: NSFetchRequest<IngredientCard> {
        NSFetchRequest(entityName: "IngredientCard")
    }

    /// Fetch all ingredient cards in descending order by creation date.
    static func all() -> NSFetchRequest<IngredientCard> {
        let request: NSFetchRequest<IngredientCard> = ingredientCardsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: false)
        ]
        return request
    }

    static func filter(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", query)
    }

    static func sortBy(_ key: SortIngredientCards) -> [NSSortDescriptor] {
        [NSSortDescriptor(key: key.rawValue, ascending: key.ascending)]
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

// MARK: - Previews
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

            let ingredient2 = Ingredient(context: context)
            ingredient2.ingredientCard = ingredientCard
            ingredient2.name = "3/4 cup (150g) sugar"

            let ingredient3 = Ingredient(context: context)
            ingredient3.ingredientCard = ingredientCard
            ingredient3.name = "pinch of kosher or sea salt"

            let ingredient4 = Ingredient(context: context)
            ingredient4.ingredientCard = ingredientCard
            ingredient4.name = "2 cups (500ml) heavy cream"

            let ingredient5 = Ingredient(context: context)
            ingredient5.ingredientCard = ingredientCard
            ingredient5.name = "4 teaspoons matcha (green tea powder)"

            let ingredient6 = Ingredient(context: context)
            ingredient6.ingredientCard = ingredientCard
            ingredient6.name = "6 large egg yolks"

            ingredientCard.ingredients = Set(
                [ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6]
            )

            cards.append(ingredientCard)
        }

        return cards
    }

    static func preview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> IngredientCard {
        return makePreview(count: 1, in: context)[0]
    }

    static func emptyPreview(
        context: NSManagedObjectContext = CoreDataController.shared.viewContext
    ) -> IngredientCard {
        return IngredientCard(context: context)
    }
}
