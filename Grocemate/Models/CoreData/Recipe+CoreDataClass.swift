//
//  Recipe+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class Recipe: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var ingredientCard: NSSet?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var recipeStep: NSSet?
}
