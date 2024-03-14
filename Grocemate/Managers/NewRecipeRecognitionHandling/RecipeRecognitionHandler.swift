//
//  RecipeRecognitionHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import SwiftUI
import Vision

struct Recipe {
    var title: String
}

protocol RecipeRecognitionHandling: ObservableObject {
    associatedtype I: ImageToTextHandling
    associatedtype O: OpenAIManaging2

    var imageToTextHandler: I { get }
    var chatGPTHandler: O { get }

    func recognizeRecipeIn(image: UIImage, with orientation: CGImagePropertyOrientation, in region: CGRect)
}

final class RecipeRecognitionHandler<I: ImageToTextHandling, O: OpenAIManaging2>: RecipeRecognitionHandling {
    // MARK: - DispatchQueue
    // Serial Dispatch Queue we will do all of our work on to ensure correct order.
    let queue: DispatchQueue = DispatchQueue(label: Constants.recipeRecognitionSessionQueue, qos: .userInitiated)

    // MARK: - RecognitionDependencies
    let imageToTextHandler: I
    let chatGPTHandler: O

    // MARK: - State
    @Published var recognitionInProgress: Bool = false
    @Published var formattedRecipe: Recipe? = nil
    @Published var recipeString: String? = nil

    init(imageToTextHandler: I = ImageToTextHandler(),
         chatGPTHandler: O = ChatGPTCloudFunctionsHandler()) {
        self.imageToTextHandler = imageToTextHandler
        self.chatGPTHandler = chatGPTHandler
    }

    func recognizeRecipeIn(image: UIImage, with orientation: CGImagePropertyOrientation, in region: CGRect) {
        DispatchQueue.main.async {
            print("Setting recognitionInProgress to true.")
            print("Current Thread: \(Thread.current)\n")
            self.recognitionInProgress = true
        }

        queue.async { [weak self] in
            guard let self = self else {
                fatalError("Unexpectedly encountered nil when unwrapping self in async block.")
            }

            self.imageToTextHandler.performImageToTextRecognition(on: image, with: orientation, in: region) { request, error in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
//                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    fatalError("Unable to cast request results.")
//                    return
                }

                /*
                 topCandidates(_:) returns an array of the top n candidates as
                 VNRecognizedText objects. Then we use [0] to get that top candidate.
                 Then we access the string parameter, which is the recognized
                 text as a String type. The resulting type of results is then [String].
                 */
                let results = observations.compactMap { observation in
                    return observation.topCandidates(1)[0].string
                }
            }
        }

        queue.async { [weak self] in
            guard let self = self else {
                fatalError("Unexpectedly encountered nil when unwrapping self in async block.")
            }

            chatGPTHandler.fakePostPrompt()
        }

        queue.async {
            DispatchQueue.main.async {
                print("Setting recognitionInProgress to false.")
                print("Current Thread: \(Thread.current)\n")
                self.recognitionInProgress = false
            }
        }
    }
}
