//
//  RecipeRecognitionHandling.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import SwiftUI

protocol RecipeRecognitionHandling: ObservableObject {
    associatedtype I: ImageToTextHandling
    associatedtype O: OpenAIManaging2

    var imageToTextHandler: I { get }
    var chatGPTHandler: O { get }
    var recognitionInProgress: Bool { get }

    func recognizeRecipeIn(image: UIImage, with orientation: CGImagePropertyOrientation, in region: CGRect)
}
