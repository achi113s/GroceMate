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

//MARK: - Previews
extension Ingredient {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Ingredient] {
        var ingredients = [Ingredient]()
        
        for _ in 0..<count {
            let ingredient = Ingredient(context: context)
            ingredient.name = "1 cup (250ml) whole milk"
            
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
