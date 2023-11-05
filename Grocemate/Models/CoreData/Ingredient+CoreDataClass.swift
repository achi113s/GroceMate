//
//  Ingredient+CoreDataClass.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//
//

import Foundation
import CoreData


public class Ingredient: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var complete: Bool
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var ingredientCard: IngredientCard?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(false, forKey: "complete")
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue("No Name", forKey: "name")
    }
}
