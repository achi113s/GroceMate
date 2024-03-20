//
//  RecipeStep+CoreDataProperties.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

// MARK: - Fetch Requests
extension RecipeStep {
    private static var recipeStepFetchRequest: NSFetchRequest<RecipeStep> {
        NSFetchRequest(entityName: "RecipeStep")
    }

    static func stepsForRecipe(_ selectedRecipe: Recipe) -> NSFetchRequest<RecipeStep> {
        let request: NSFetchRequest<RecipeStep> = recipeStepFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(key: "step", ascending: false)
        ]
        request.predicate = NSPredicate(format: "recipe == %@", selectedRecipe)

        return request
    }
}

// MARK: - Previews
extension RecipeStep {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [RecipeStep] {
        var recipeSteps = [RecipeStep]()

        for _ in 0..<count {
            let step = RecipeStep(context: context)
            step.stepText = "1. Preheat the oven to 400˚F (200˚C)."

            recipeSteps.append(step)
        }

        return recipeSteps
    }

    static func preview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> RecipeStep {
        return makePreview(count: 1, in: context)[0]
    }

    static func emptyPreview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> RecipeStep {
        return RecipeStep(context: context)
    }
}
