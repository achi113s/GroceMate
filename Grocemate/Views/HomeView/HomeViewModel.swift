//
//  HomeViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/17/23.
//

import CoreData
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var path = NavigationPath()

    @Published var sheet: Sheets?

    @Published var presentConfirmationDialog: Bool = false
    @Published var presentPhotosPicker: Bool = false
    @Published var presentRecognitionInProgress: Bool = false

    @Published var deleteAlert = false

    @Published var selectedCard: IngredientCard?

    private let context: NSManagedObjectContext

    init(coreDataController: CoreDataController) {
        self.context = coreDataController.viewContext
    }

    public func deleteSelectedCard() throws {
        guard let card = selectedCard else { return }

        /// Bug: Does not delete with an animation.
        let existingIngredientCard = try context.existingObject(with: card.objectID)
        context.delete(existingIngredientCard)

        /// Task to delete from context on background thread.
        Task(priority: .background) {
            try await context.perform {
                try self.context.save()
            }
        }
    }
}
