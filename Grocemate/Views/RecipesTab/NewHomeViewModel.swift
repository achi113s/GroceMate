//
//  NewHomeViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/20/24.
//

import CoreData
import PhotosUI
import SwiftUI

enum SortRecipes {
    case timestampAsc, timestampDesc, titleAsc, titleDesc

    var rawValue: String {
        switch self {
        case .timestampAsc, .timestampDesc:
            return "timestamp"
        case .titleAsc, .titleDesc:
            return "title"
        }
    }

    var ascending: Bool {
        switch self {
        case .timestampAsc, .titleAsc:
            return true
        case .timestampDesc, .titleDesc:
            return false
        }
    }
}

final class NewHomeViewModel: ObservableObject {
    @Published var path = NavigationPath()

    @Published var sheet: Sheets?

    @Published var presentConfirmationDialog: Bool = false
    @Published var presentPhotosPicker: Bool = false
    @Published var presentRecognitionInProgress: Bool = false

    @Published var deleteAlert = false

    @Published var selectedCard: IngredientCard?
    @Published var selectedPhotosPickerItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?

    @Published var query: String = ""
    @Published var sortBy: SortIngredientCards = .timestampAsc

    private let context: NSManagedObjectContext

    init(coreDataController: CoreDataController) {
        self.context = coreDataController.viewContext
    }
}

