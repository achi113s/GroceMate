//
//  IngredientCard+CoreDataClass.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//
//

import Foundation
import CoreData

public class IngredientCard: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientCard> {
        return NSFetchRequest<IngredientCard>(entityName: "IngredientCard")
    }

    @NSManaged public var id: UUID
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String
    @NSManaged public var ingredients: Set<Ingredient>
    
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
        setPrimitiveValue("No Title", forKey: "title")
    }
}
