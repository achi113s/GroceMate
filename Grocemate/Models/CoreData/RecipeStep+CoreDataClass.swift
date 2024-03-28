//
//  RecipeStep+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class RecipeStep: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeStep> {
        return NSFetchRequest<RecipeStep>(entityName: "RecipeStep")
    }

    @NSManaged public var stepText: String
    @NSManaged public var id: UUID?
    @NSManaged public var recipe: Recipe?
    @NSManaged public var stepNumber: Int16

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue("Preheat the oven.", forKey: "stepText")
        setPrimitiveValue(1, forKey: "stepNumber")
    }
}
