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
    case formattingIngredients = "Formatting ingredient text..."
    case doneFormattingIngredients = "Done formatting ingredient text!"
    case formattingError = "There was an error formatting the ingredients."

    case done = "Done!"
}

enum IngredientRecognitionError: Error {
    case undefinedImage, unknownError
}

enum ChatGPTCompletionsError: Error {
    case unknownError, requestObjectEncodingError
}
