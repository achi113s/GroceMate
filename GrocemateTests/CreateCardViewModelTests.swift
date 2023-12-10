//
//  CreateCardViewModelTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/9/23.
//

import CoreData
@testable import Grocemate
import SwiftUI
import XCTest

final class CreateCardViewModelTests: XCTestCase {

    private var coreDataController: CoreDataController!
    private var createCardViewModel: CreateCardViewModel!
    private var testIngredientCard: IngredientCard!

    override func setUpWithError() throws {
        coreDataController = .shared
        testIngredientCard = IngredientCard.emptyPreview(context: coreDataController.newContext)
        createCardViewModel = CreateCardViewModel(
            coreDataController: coreDataController
        )
    }

    override func tearDownWithError() throws {
        try coreDataController.delete(testIngredientCard, in: coreDataController.newContext)
        coreDataController = nil
        createCardViewModel = nil
    }

    func testAddDummyIngredient() {
        /// Add an ingredient to the ingredients property of the view model.
        let countBefore = createCardViewModel.ingredients.count

        createCardViewModel.addDummyIngredient()

        XCTAssertEqual(
            countBefore + 1,
            createCardViewModel.ingredients.count,
            "The ingredients count is not exactly one more than it was before adding a new ingredient."
        )
    }

    func testSetIngredientsToCard() {
        let newIngredients = [
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext)
        ]

        createCardViewModel.ingredients = newIngredients

        createCardViewModel.setIngredientsToCard()

        let setNewIngredients = Set(newIngredients)

        XCTAssertEqual(
            createCardViewModel.card.ingredients,
            setNewIngredients,
            "The new ingredients do not match the ingredients of the card."
        )
    }

    func testSetCardTitle() {
        createCardViewModel.title = "Test title"

        createCardViewModel.setCardTitle()

        XCTAssertEqual(
            createCardViewModel.title,
            createCardViewModel.card.title,
            "The card's title does not equal the viewModel title property after setting it to the card."
        )
    }

    func testClearTitleClearsTitle() {
        createCardViewModel.title = "Test title"

        createCardViewModel.clearTitle()

        XCTAssertEqual(
            createCardViewModel.title,
            "",
            "The card's title was not cleared correctly."
        )
    }

    func testDeleteSingleIngredientFromModelArray() {
        var newIngredients = [
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext)
        ]

        createCardViewModel.ingredients = newIngredients

        createCardViewModel.deleteIngredient(IndexSet(integer: 0))
        newIngredients = Array(newIngredients.dropFirst())

        XCTAssertEqual(
            newIngredients,
            createCardViewModel.ingredients,
            "Deleting the first element produced inconsistent results."
        )
    }

    func testDeleteAllIngredientFromModelArray() {
        let newIngredients = [
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext)
        ]

        createCardViewModel.ingredients = newIngredients

        createCardViewModel.deleteIngredient(IndexSet([0, 1, 2]))

        XCTAssertEqual(
            [Ingredient](),
            createCardViewModel.ingredients,
            "Deleting all ingredient elements produced inconsistent results."
        )
    }

    func testDeleteNoIngredientFromModelArray() {
        let newIngredients = [
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext),
            Ingredient(context: coreDataController.newContext)
        ]

        createCardViewModel.ingredients = newIngredients

        createCardViewModel.deleteIngredient(IndexSet([]))

        XCTAssertEqual(
            newIngredients,
            createCardViewModel.ingredients,
            "Deleting no ingredient elements produced inconsistent results."
        )
    }

    func testSaveWithBlankTitleProducesError() throws {
        createCardViewModel.title = ""

        XCTAssertThrowsError(
            try createCardViewModel.save(),
            "EditCardViewModel save did not throw error with blank title."
        )
    }

    func testSaveWithTitleOfSpacesTitleProducesError() throws {
        createCardViewModel.title = "                 "

        XCTAssertThrowsError(
            try createCardViewModel.save(),
            "EditCardViewModel save did not throw error with blank title."
        )
    }

    func testSaveWithNoIngredientsProducesError() throws {
        let newIngredients = [Ingredient]()

        createCardViewModel.ingredients = newIngredients

        XCTAssertThrowsError(
            try createCardViewModel.save(),
            "EditCardViewModel save did not throw error with empty ingredients."
        )
    }

    func testSaveWithABlankIngredientsProducesError() throws {
        let testIngredient1 = Ingredient(context: coreDataController.newContext)
        testIngredient1.name = ""

        let testIngredient2 = Ingredient(context: coreDataController.newContext)
        testIngredient2.name = "chicken"

        createCardViewModel.ingredients = [testIngredient1, testIngredient2]

        XCTAssertThrowsError(
            try createCardViewModel.save(),
            "EditCardViewModel save did not throw error with an ingredient with blank title."
        )
    }
}
