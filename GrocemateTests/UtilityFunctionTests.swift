//
//  UtilityFunctionTests.swift
//  GrocemateTests
//
//  Created by Giorgio Latour on 12/12/23.
//

@testable import Grocemate
import XCTest

final class UtilityFunctionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringArrayHasEmptyStringsBlank() {
        let strArray: [String] = []

        let result: Bool = strArray.areThereEmptyStrings()

        XCTAssertFalse(result, "AreThereEmptyStrings did not return false for empty array.")
    }

    func testStringArrayHasEmptyStringsTrue() {
        let strArray: [String] = [
            "      ", "    a   ", "sdf", "a     ",
            "asdfasdfasdfasdfasdf", "asdf   asdfasfdl.", "\n\n"
        ]

        let result: Bool = strArray.areThereEmptyStrings()

        XCTAssertTrue(result, "AreThereEmptyStrings returned false when it should have returned true.")
    }

    func testStringArrayHasEmptyStringsFalse() {
        let strArray: [String] = ["asdfa", ",,,,,", "asdfasdf"]

        let result: Bool = strArray.areThereEmptyStrings()

        XCTAssertFalse(result, "AreThereEmptyStrings returned true when it should have returned false.")
    }
}
