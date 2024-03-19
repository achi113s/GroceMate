//
//  IngredientCard+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class IngredientCard: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientCard> {
        return NSFetchRequest<IngredientCard>(entityName: "IngredientCard")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String
    @NSManaged public var ingredients: Set<Ingredient>
    @NSManaged public var recipe: Recipe?

    public var ingredientsArr: [Ingredient] {
        let arr = Array(ingredients)
        return arr.sorted { lhs, rhs in
            lhs.name < rhs.name
        }
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Date.now, forKey: "timestamp")
        setPrimitiveValue("Card Title", forKey: "title")
    }
}
