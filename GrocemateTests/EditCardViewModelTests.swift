//
//  EditCardViewModelTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/5/23.
//

import CoreData
@testable import Grocemate
import SwiftUI
import XCTest

final class EditCardViewModelTests: XCTestCase {

    private var coreDataController: CoreDataController!
    private var editCardViewModel: EditCardViewModel!
    private var testIngredientCard: IngredientCard!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataController = .shared
        testIngredientCard = IngredientCard.emptyPreview(context: coreDataController.viewContext)
        editCardViewModel = EditCardViewModel(
            coreDataController: coreDataController,
            ingredientCard: testIngredientCard
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try coreDataController.delete(testIngredientCard, in: coreDataController.viewContext)
        coreDataController = nil
        editCardViewModel = nil
    }

    func testViewModelCardIsInputCard() {
        XCTAssertIdentical(
            editCardViewModel.card.objectID,
            testIngredientCard.objectID,
            "The input ingredient card is not equal to the view model's card."
        )
    }

    func testAddDummyIngredient() {
        /// Add an ingredient to the ingredients property of the view model.
        let countBefore = editCardViewModel.ingredients.count

        editCardViewModel.addDummyIngredient()

        XCTAssertEqual(
            countBefore + 1,
            editCardViewModel.ingredients.count,
            "The ingredients count is not exactly one more than it was before adding a new ingredient."
        )
    }

    func testSetIngredientsToCard() {
        let newIngredients = [
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext)
        ]

        editCardViewModel.ingredients = newIngredients

        editCardViewModel.setIngredientsToCard()

        let setNewIngredients = Set(newIngredients)

        XCTAssertEqual(
            editCardViewModel.card.ingredients,
            setNewIngredients,
            "The new ingredients do not match the ingredients of the card."
        )
    }

    func testSetCardTitle() {
        editCardViewModel.title = "Test title"

        editCardViewModel.setCardTitle()

        XCTAssertEqual(
            editCardViewModel.title,
            editCardViewModel.card.title,
            "The card's title does not equal the viewModel title property after setting it to the card."
        )
    }

    func testClearTitleClearsTitle() {
        editCardViewModel.title = "Test title"

        editCardViewModel.clearTitle()

        XCTAssertEqual(
            editCardViewModel.title,
            "",
            "The card's title was not cleared correctly."
        )
    }

    func testDeleteSingleIngredientFromModelArray() {
        var newIngredients = [
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext)
        ]

        editCardViewModel.ingredients = newIngredients

        editCardViewModel.deleteIngredient(IndexSet(integer: 0))
        newIngredients = Array(newIngredients.dropFirst())

        XCTAssertEqual(
            newIngredients,
            editCardViewModel.ingredients,
            "Deleting the first element produced inconsistent results."
        )
    }

    func testDeleteAllIngredientFromModelArray() {
        var newIngredients = [
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext)
        ]

        editCardViewModel.ingredients = newIngredients

        editCardViewModel.deleteIngredient(IndexSet([0, 1, 2]))

        XCTAssertEqual(
            [Ingredient](),
            editCardViewModel.ingredients,
            "Deleting all ingredient elements produced inconsistent results."
        )
    }

    func testDeleteNoIngredientFromModelArray() {
        var newIngredients = [
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext),
            Ingredient(context: coreDataController.viewContext)
        ]

        editCardViewModel.ingredients = newIngredients

        editCardViewModel.deleteIngredient(IndexSet([]))

        XCTAssertEqual(
            [Ingredient](),
            editCardViewModel.ingredients,
            "Deleting no ingredient elements produced inconsistent results."
        )
    }

    func testSaveWithBlankTitleProducesError() throws {
        editCardViewModel.title = ""

        XCTAssertThrowsError(
            try editCardViewModel.save(),
            "EditCardViewModel save did not throw error with blank title."
        )
    }

    func testSaveWithTitleOfSpacesTitleProducesError() throws {
        editCardViewModel.title = "                 "

        XCTAssertThrowsError(
            try editCardViewModel.save(),
            "EditCardViewModel save did not throw error with blank title."
        )
    }

    func testSaveWithNoIngredientsProducesError() throws {
        var newIngredients = [Ingredient]()

        editCardViewModel.ingredients = newIngredients

        XCTAssertThrowsError(
            try editCardViewModel.save(),
            "EditCardViewModel save did not throw error with empty ingredients."
        )
    }

    func testSaveWithABlankIngredientsProducesError() throws {
        var testIngredient1 = Ingredient(context: coreDataController.viewContext)
        testIngredient1.name = ""

        var testIngredient2 = Ingredient(context: coreDataController.viewContext)
        testIngredient2.name = "chicken"

        editCardViewModel.ingredients = [testIngredient1, testIngredient2]

        XCTAssertThrowsError(
            try editCardViewModel.save(),
            "EditCardViewModel save did not throw error with an ingredient with blank title."
        )
    }
}
