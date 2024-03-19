//
//  Recipe+CoreDataProperties.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

// MARK: Generated accessors for ingredientCard
extension Recipe {

    @objc(addIngredientCardObject:)
    @NSManaged public func addToIngredientCard(_ value: IngredientCard)

    @objc(removeIngredientCardObject:)
    @NSManaged public func removeFromIngredientCard(_ value: IngredientCard)

    @objc(addIngredientCard:)
    @NSManaged public func addToIngredientCard(_ values: NSSet)

    @objc(removeIngredientCard:)
    @NSManaged public func removeFromIngredientCard(_ values: NSSet)

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for recipeStep
extension Recipe {

    @objc(addRecipeStepObject:)
    @NSManaged public func addToRecipeStep(_ value: RecipeStep)

    @objc(removeRecipeStepObject:)
    @NSManaged public func removeFromRecipeStep(_ value: RecipeStep)

    @objc(addRecipeStep:)
    @NSManaged public func addToRecipeStep(_ values: NSSet)

    @objc(removeRecipeStep:)
    @NSManaged public func removeFromRecipeStep(_ values: NSSet)

}

extension Recipe : Identifiable {

}
