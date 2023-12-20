//
//  IngredientRecognitionStage.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

enum IngredientRecognitionStage: String {
    case startingVision = "Recognizing ingredients..."
    case doneWithVision = "Done recognizing ingredients!"
    case parsingIngredients = "Formatting ingredient text..."
    case doneParsingIngredients = "Done formatting ingredient text!"
    case done = "Done!"
}

enum IngredientRecognitionError: Error {
    case undefinedImage, unknownError
}
