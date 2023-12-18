//
//  HomeViewModelTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/11/23.
//

@testable import Grocemate
import XCTest

final class HomeViewModelTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testInitializeHomeViewModel() {
        let homeViewModel = HomeViewModel(coreDataController: CoreDataController.shared)

        XCTAssertEqual(
            homeViewModel.path.count,
            0,
            "The navigation path is not initialized with a clean path."
        )
        XCTAssertNil(
            homeViewModel.sheet,
            "The sheets property has a value when it should be nil."
        )
        XCTAssertFalse(
            homeViewModel.presentConfirmationDialog,
            "The view model is modelling presentation of a view when it shouldn't."
        )
        XCTAssertFalse(
            homeViewModel.presentPhotosPicker,
            "The home view model is modelling presentation of a view when it shouldn't."
        )
        XCTAssertFalse(
            homeViewModel.presentRecognitionInProgress,
            "The home view model is modelling presentation of a view when it shouldn't."
        )
        XCTAssertFalse(
            homeViewModel.deleteAlert,
            "The home view model is showing a delete alert when it shouldn't."
        )
        XCTAssertNil(
            homeViewModel.selectedCard,
            "An IngredientCard is selected when there shouldn't be one selected yet."
        )
        XCTAssertEqual(
            homeViewModel.query,
            "",
            "The query string is not empty on initialization."
        )
        XCTAssertNotNil(homeViewModel.sortBy, "There is not sorting parameter set.")
    }
}
