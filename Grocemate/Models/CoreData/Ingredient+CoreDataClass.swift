//
//  Ingredient+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class Ingredient: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var ingredientCard: IngredientCard?
    @NSManaged public var recipe: Recipe?

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(false, forKey: "complete")
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue("", forKey: "name")
    }
}
