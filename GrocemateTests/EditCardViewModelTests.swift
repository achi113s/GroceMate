//
//  EditCardViewModelTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/5/23.
//

@testable import Grocemate
import SwiftUI
import XCTest

final class EditCardViewModelTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

class TesterEditCardViewModel: CardDetailViewModellable {
    var editMode: EditMode

    var titleError: Bool

    var ingredientsError: Bool

    var card: Grocemate.IngredientCard

    var ingredients: [Grocemate.Ingredient]

    init(editMode: EditMode, titleError: Bool,
         ingredientsError: Bool, card: Grocemate.IngredientCard,
         ingredients: [Grocemate.Ingredient]
    ) {
        self.editMode = editMode
        self.titleError = titleError
        self.ingredientsError = ingredientsError
        self.card = card
        self.ingredients = ingredients
    }

    func addIngredient() {

    }

    func addIngredientsToCard() {

    }

    func deleteIngredient(_ indexSet: IndexSet) {

    }

    func save() throws {

    }
}
