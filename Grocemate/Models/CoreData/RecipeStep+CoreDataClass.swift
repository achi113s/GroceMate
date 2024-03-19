//
//  RecipeStep+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class RecipeStep: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeStep> {
        return NSFetchRequest<RecipeStep>(entityName: "RecipeStep")
    }

    @NSManaged public var step: String?
    @NSManaged public var recipe: Recipe?
}

