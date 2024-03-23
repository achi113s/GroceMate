//
//  RecipeRecognitionHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import SwiftUI
import Vision

final class RecipeRecognitionHandler<I: ImageToTextHandling, O: OpenAIManaging2>: RecipeRecognitionHandling {
    // MARK: - DispatchQueue
    // Serial Dispatch Queue we will do all of our work on to ensure correct order.
    let queue: DispatchQueue = DispatchQueue(label: Constants.recipeRecognitionSessionQueue, qos: .userInitiated)

    // MARK: - RecognitionDependencies
    let imageToTextHandler: I
    let chatGPTHandler: O

    // MARK: - State
    @Published var recognitionInProgress: Bool = false
    @Published var formattedRecipe: Recipe?
    @Published var recipeString: String?

    var visionResults: [String]?

    init(imageToTextHandler: I = ImageToTextHandler(),
         chatGPTHandler: O = ChatGPTCloudFunctionsHandler()) {
        self.imageToTextHandler = imageToTextHandler
        self.chatGPTHandler = chatGPTHandler
    }

    func recognizeRecipeIn(images: [UIImage], with orientation: CGImagePropertyOrientation = .right,
                           in region: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) {
        DispatchQueue.main.async {
            print("Setting recognitionInProgress to true.")
            print("Current Thread: \(Thread.current)\n")
            self.recognitionInProgress = true
        }

        performImageRecognition(images: images, with: orientation, in: region)

        performChatGPTParsing()
    }

    private func performImageRecognition(images: [UIImage], with orientation: CGImagePropertyOrientation,
                                         in region: CGRect) {
        for image in images {
            queue.async { [weak self] in
                guard let self = self else {
                    fatalError("Unexpectedly encountered nil when unwrapping self in async block.")
                }

                self.imageToTextHandler.performImageToTextRecognition(on: image,
                                                                      with: orientation, in: region) { request, error in
                    guard error == nil else {
                        fatalError(error!.localizedDescription)
                    }

                    guard let observations = request.results as? [VNRecognizedTextObservation] else {
                        fatalError("Unable to cast request results.")
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

                    self.visionResults = results
                }
            }
        }
    }

    private func performChatGPTParsing() {
        queue.async { [weak self] in
            guard let self = self else {
                fatalError("Unexpectedly encountered nil when unwrapping self in async block.")
            }

            guard let ingredients = visionResults?.joined(separator: " ") else {
                fatalError("Unexpectedly encountered nil when unwrapping visionResults.")
            }

//            let content = Constants.separateIngredientsPrompt + "\"\(ingredients)\""

            /// Construct the input and make the call to ChatGPT.
            let message = Message(role: "system", content: "\"\(ingredients)\"")
            let requestObject = CompletionRequest(
                model: Chat.chatgpt.rawValue, maxTokens: 1000,
                messages: [message], temperature: 0.7, stream: false
            )

            chatGPTHandler.postRequestToCompletionsEndpoint(requestObject: requestObject) { openAIResponse, error in
                guard error == nil else {
                    print("An error occurred posting a message to ChatGPT Completions: \(error!.localizedDescription)")
                    return
                }

                guard let openAIResponse = openAIResponse else {
                    print("OpenAIResponse was nil.\n")
                    return
                }

                let ingredientJSONString = openAIResponse.choices[0].message.content

                /// Try to convert the JSON string from ChatGPT into a JSON Data object.
                guard let ingredientJSON = ingredientJSONString.data(using: .utf8) else {
                    print("Could not cast ingredientJSONString as JSON Object.\n")
                    return
                }

                /// Try to decode the JSON object into a DecodedIngredients object.
                guard let ingredientsObj = try? JSONDecoder().decode(
                    DecodedIngredients.self, from: ingredientJSON
                ) else {
                    print("Could not decode ingredientJSON to DecodedIgredients.\n")
                    return
                }

                print("Here are the ingredients:")
                print(ingredientsObj)

                DispatchQueue.main.async {
                    print("Setting recognitionInProgress to false.")
                    print("Current Thread: \(Thread.current)\n")
                    self.recognitionInProgress = false
                }
            }
        }
    }
}
