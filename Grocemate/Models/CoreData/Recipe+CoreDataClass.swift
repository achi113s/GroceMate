//
//  Recipe+CoreDataClass.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

public class Recipe: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date
    @NSManaged public var title: String
    @NSManaged public var yield: String
    @NSManaged public var ingredientCards: Set<IngredientCard>
    @NSManaged public var ingredients: Set<Ingredient>
    @NSManaged public var recipeSteps: Set<RecipeStep>
    @NSManaged public var notes: String

    public var ingredientsArr: [Ingredient] {
        let arr = Array(ingredients)
        return arr.sorted { lhs, rhs in
            lhs.name < rhs.name
        }
    }

    public var recipeStepsArr: [RecipeStep] {
        let arr = Array(recipeSteps)
        return arr.sorted { lhs, rhs in
            lhs.stepNumber < rhs.stepNumber
        }
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Date.now, forKey: "timestamp")
        setPrimitiveValue("Recipe Title", forKey: "title")
        setPrimitiveValue("", forKey: "yield")
        setPrimitiveValue("", forKey: "notes")
    }
}
