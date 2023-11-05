//
//  CreateCardViewModel.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/5/23.
//

import CoreData
import Foundation
import SwiftUI

final class CreateCardViewModel: ObservableObject {
    /// Create a Published temporary instance of an ingredient card
    /// to use in our view.
    @Published var tempCard: IngredientCard
    @Published var editMode: EditMode = .active
    
    /// Use a new context as a temporary editing board outside
    /// the main view context.
    private let context: NSManagedObjectContext
    
    init(coreDataController: CoreDataController, card: IngredientCard? = nil) {
        self.context = coreDataController.newContext
        self.tempCard = IngredientCard(context: self.context)
        self.tempCard.title = "Green Tea Ice Cream"
        // how to initialize the ingredients?
        // what if we use a temporary ingreidnet card struct to show the view, and then
        // the properties of the struct are used to create coredata entities on save?
        // 42:23
    }
    
    public func save() throws {
        guard self.context.hasChanges else { return }
        
        try self.context.save()
        print("Saved")
    }
}
