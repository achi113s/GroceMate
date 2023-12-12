//
//  CreateCardViewModelInitializerTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/11/23.
//

import CoreData
@testable import Grocemate
import SwiftUI
import XCTest

final class CreateCardViewModelInitializerTests: XCTestCase {

    private var coreDataController: CoreDataController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataController = CoreDataController.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataController = nil
    }

    func testInitializerCreateCardViewModelForManualAdd() {
        let viewModel = CreateCardViewModel(
            coreDataController: coreDataController,
            context: coreDataController.newContext
        )

        XCTAssertEqual(viewModel.editMode, EditMode.active, "The editing state was not initialized as active.")
        XCTAssertFalse(viewModel.titleError, "The titleError property was not initialized as false.")
        XCTAssertFalse(viewModel.ingredientsError, "The ingredientsError property was not initialized as false.")
        XCTAssertNotNil(viewModel.card, "The IngredientCard property in CreateCardViewModel was not initialized.")
        XCTAssertNotEqual(viewModel.title, "", "The title property in CreateCardViewModel was not initialized.")
        XCTAssertNotEqual(
            viewModel.ingredients.count,
            0,
            "The Ingredient array was not initialized with at least one Ingredient object."
        )
    }

    func testInitializerCreateCardViewModelForVisionChatGPTAdd() {
        let tempCardName = "Test Card"
        let tempCardIngredient = "1 cup pasta"
        let tempCard = TempIngredientCard(title: tempCardName, ingredients: [tempCardIngredient])

        let viewModel = CreateCardViewModel(coreDataController: coreDataController,
                                            tempCard: tempCard,
                                            context: coreDataController.newContext
        )

        XCTAssertEqual(viewModel.editMode, .active, "The editing state was not initialized as active.")
        XCTAssertFalse(viewModel.titleError, "The titleError property was not initialized as false.")
        XCTAssertFalse(viewModel.ingredientsError, "The ingredientsError property was not initialized as false.")
        XCTAssertNotNil(
            viewModel.card,
            "The IngredientCard property in CreateCardViewModel was not initialized."
        )
        XCTAssertEqual(
            viewModel.title,
            tempCardName,
            "The title property in CreateCardViewModel was not initialized correctly."
        )
        XCTAssertEqual(
            viewModel.ingredients.first!.name,
            tempCardIngredient,
            "The Ingredient array was not initialized with the correct input ingredients."
        )
    }
}
