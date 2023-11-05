//
//  DataController.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/4/23.
//

import CoreData
import Foundation

final class CoreDataController {
    
    /// Create a singleton instance of this class.
    static let shared = CoreDataController()
    
    private let persistentContainer: NSPersistentContainer
    
    /// The main view context.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// A background context to use in our views for editing CoreData objects.
    /// This background context executes on a private queue.
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
//    /// Use a Published array with our NSManagedObjects so that changes are published.
//    @Published var savedCards: [IngredientCard] = []
//    
    private init() {
//        #if DEBUG
//        do {
//            // Use the container to initialize the development schema.
//            try persistentContainer.initializeCloudKitSchema(options: [])
//        } catch {
//            // Handle any errors.
//            print("An error occurred initializing the development schema: \(error.localizedDescription)")
//        }
//        #endif
        
        /// Set up the model, context, and store all at once with an NSPersistentContainer.
        persistentContainer = NSPersistentContainer(name: "GrocemateDataModel")
        
        /// Automatically merge any changes saved to the parent store. Useful since we will have multiple viewContexts.
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        /// Load the persistent stores.
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                print("There was an error loading the persistent stores: \(error.localizedDescription)")
                return
            } else {
                self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                print("Successfully loaded CoreData.")
            }
        }
    }
    
//    func fetchIngredientCards() {
//        let request = NSFetchRequest<IngredientCard>(entityName: "IngredientCard")
//        
//        do {
//            savedCards = try persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Error fetching: \(error)")
//        }
//    }
    
//    func addCard(title: String = "No Title", ingredients: [String] = [String]()) {
//        let newCard = IngredientCard(context: persistentContainer.viewContext)
//        newCard.title = title
//        newCard.id = UUID()
//        newCard.timestamp = Date.now
//        
//        let ingredientsArr = ingredients.map { ingredient in
//            let newIngredient = Ingredient(context: persistentContainer.viewContext)
//            newIngredient.complete = false
//            newIngredient.id = UUID()
//            newIngredient.ingredient = ingredient
//            newIngredient.ingredientCard = newCard
//            
//            return newIngredient
//        }
//
//        newCard.ingredients = NSSet(array: ingredientsArr)
//        
//        saveData()
//    }
//    
//    func saveData() {
//        do {
//            try persistentContainer.viewContext.save()
//            fetchIngredientCards()
//        } catch {
//            print("Error saving view context: \(error)")
//        }
//    }
}


