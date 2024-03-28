//
//  Recipe+CoreDataProperties.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//
//

import Foundation
import CoreData

// MARK: - Fetch Requests
extension Recipe {
    private static var recipesFetchRequest: NSFetchRequest<Recipe> {
        NSFetchRequest(entityName: "Recipe")
    }

    /// Fetch all recipes in descending order by creation date.
    static func all() -> NSFetchRequest<Recipe> {
        let request: NSFetchRequest<Recipe> = recipesFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ]
        return request
    }

    static func filter(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", query)
    }

    static func sortBy(_ key: SortRecipes) -> [NSSortDescriptor] {
        [NSSortDescriptor(key: key.rawValue, ascending: key.ascending)]
    }
}

// MARK: - Previews
extension Recipe {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Recipe] {
        var recipes = [Recipe]()

        for _ in 0..<count {
            let recipe = Recipe(context: context)
            recipe.title = "Green Tea Ice Cream"
            recipe.yield = "1 quart (1l)"

            let ingredientCard = IngredientCard(context: context)
            ingredientCard.title = recipe.title

            // Ingredients
            let ingredient1 = Ingredient(context: context)
            ingredient1.ingredientCard = ingredientCard
            ingredient1.name = "1 cup (250ml) whole milk"

            let ingredient2 = Ingredient(context: context)
            ingredient2.ingredientCard = ingredientCard
            ingredient2.name = "3/4 cup (150g) sugar"

            let ingredient3 = Ingredient(context: context)
            ingredient3.ingredientCard = ingredientCard
            ingredient3.name = "pinch of kosher or sea salt"

            let ingredient4 = Ingredient(context: context)
            ingredient4.ingredientCard = ingredientCard
            ingredient4.name = "2 cups (500ml) heavy cream"

            let ingredient5 = Ingredient(context: context)
            ingredient5.ingredientCard = ingredientCard
            ingredient5.name = "4 teaspoons matcha (green tea powder)"

            let ingredient6 = Ingredient(context: context)
            ingredient6.ingredientCard = ingredientCard
            ingredient6.name = "6 large egg yolks"

            // Add the ingredients to the recipe.
            recipe.ingredients = Set(
                [ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6]
            )

            // Add the ingredients to the ingredient card.
            ingredientCard.ingredients = Set(
                [ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6]
            )

            // Add the ingredient card to the recipe.
            recipe.ingredientCards = Set(
                [ingredientCard]
            )

            // Recipe Steps
            let recipeStep1 = RecipeStep(context: context)
            recipeStep1.recipe = recipe
            recipeStep1.stepNumber = 1
            recipeStep1.stepText = """
            Warm the milk, sugar, and salt in a medium saucepan. \
            Pour the cream into the large bowl and vigorously whisk \
            in the matcha. Set a mesh strainer on top.
            """

            let recipeStep2 = RecipeStep(context: context)
            recipeStep2.stepNumber = 2
            recipeStep2.recipe = recipe
            recipeStep2.stepText = """
            In a separate medium bowl, whisk together the egg yolks. \
            Slowly pour the warm mixture into the egg yolks, whisking \
            constantly, then scrape the warmed egg yolks into the saucepan. \
            Stire the mixture constantly with a heatproof spatula over medium \
            heat, scraping the bottom as you stir, until the mixture \
            thickens and coats the spatula.
            """

            let recipeStep3 = RecipeStep(context: context)
            recipeStep3.stepNumber = 3
            recipeStep3.recipe = recipe
            recipeStep3.stepText = """
            Pour the custard through the strainer and stir it into the \
            cream, then whisk it vigorously until the custard is froth to \
            dissolve the matcha. Stir over an ice bath until cool.
            """

            let recipeStep4 = RecipeStep(context: context)
            recipeStep4.stepNumber = 4
            recipeStep4.recipe = recipe
            recipeStep4.stepText = """
            Chill the mixture thoroughly in the refrigerator, then freeze it \
            in your ice cream maker according to the manufacturer's instructions.
            """

            // Add the recipe steps to the recipe.
            recipe.recipeSteps = Set(
                [recipeStep1, recipeStep2, recipeStep3, recipeStep4]
            )

            recipes.append(recipe)
        }

        return recipes
    }

    static func preview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> Recipe {
        return makePreview(count: 1, in: context)[0]
    }

    static func emptyPreview(context: NSManagedObjectContext = CoreDataController.shared.viewContext) -> Recipe {
        return Recipe(context: context)
    }
}

// MARK: Generated accessors for ingredientCard
extension Recipe {
    @objc(addIngredientCardObject:)
    @NSManaged public func addToIngredientCards(_ value: IngredientCard)

    @objc(removeIngredientCardObject:)
    @NSManaged public func removeFromIngredientCards(_ value: IngredientCard)

    @objc(addIngredientCard:)
    @NSManaged public func addToIngredientCards(_ values: NSSet)

    @objc(removeIngredientCard:)
    @NSManaged public func removeFromIngredientCards(_ values: NSSet)
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
    @NSManaged public func addToRecipeSteps(_ value: RecipeStep)

    @objc(removeRecipeStepObject:)
    @NSManaged public func removeFromRecipeSteps(_ value: RecipeStep)

    @objc(addRecipeStep:)
    @NSManaged public func addToRecipeSteps(_ values: NSSet)

    @objc(removeRecipeStep:)
    @NSManaged public func removeFromRecipeSteps(_ values: NSSet)
}
