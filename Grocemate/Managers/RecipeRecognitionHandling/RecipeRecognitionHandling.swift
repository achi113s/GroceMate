//
//  RecipeRecognitionHandling.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import SwiftUI

protocol RecipeRecognitionHandling: ObservableObject {
    associatedtype ItoT: ImageToTextHandling
    associatedtype OAM: OpenAIManaging2

    var imageToTextHandler: ItoT { get }
    var chatGPTHandler: OAM { get }
    var recognitionInProgress: Bool { get }
    var recognizedRecipe: DecodedRecipe? { get }

    func recognizeRecipeIn(images: [UIImage], with orientation: CGImagePropertyOrientation, in region: CGRect)
}
