//
//  IngredientRecognitionHandler.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Combine
import SwiftUI
import Vision

/// This class manages calls to Vision for image-to-text
/// recognition and also sends the output to ChatGPT
/// for analysis and formatting using OpenAIManager.
class IngredientRecognitionHandler: ObservableObject {
    let textRecognitionSessionQueue = DispatchQueue(label: Konstants.textRecognitionSessionQueueName, qos: .background)

    @Published var progressStage: String = IngredientRecognitionStage.done.rawValue
    @Published var recognitionInProgress: Bool = false
    @Published var presentNewIngredients: Bool = false

    private var lastResultsFromVision: [String]?
    public var lastIngredientGroupFromChatGPT: DecodedIngredients?

    private let separateIngredientsCompletion = """
         Separate this ingredient list into an array of strings of its
         components and output as a JSON object. The JSON object should
         have the following format: {"ingredients": []}.
         Here are the ingredients:
        """

    private var openAIManager: OpenAIManager

    init(openAIManager: OpenAIManager) {
        self.openAIManager = openAIManager
    }

    /// The public function for performing ingredients in an image.
    public func recognizeIngredientsInImage(image: UIImage, region: CGRect) {
        /// First set these two progress variables on main thread.
        textRecognitionSessionQueue.async { [weak self] in
            DispatchQueue.main.async { [weak self] in
                print("Setting recognitionInProgress to true and setting progressMessage")
                print("Current Thread: \(Thread.current)\n")
                withAnimation {
                    self?.recognitionInProgress = true
                    self?.progressStage = IngredientRecognitionStage.startingVision.rawValue
                }
            }
        }

        /// Move to the textRecognitionSessionQueue for the text recognition with Vision.
        textRecognitionSessionQueue.async { [weak self] in
            do {
                try self?.performImageToTextRecognition(on: image, in: region)
            } catch {
                DispatchQueue.main.async {
                    self?.progressStage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                withAnimation {
                    self?.recognitionInProgress = false
                }
            }
        }

        /// A second async block for the ChatGPT API call.
        textRecognitionSessionQueue.async { [weak self] in
            DispatchQueue.main.async {
                print("Setting progressMessage to parsing ingredients.")
                print("Current Thread: \(Thread.current)\n")
                withAnimation {
                    self?.progressStage = IngredientRecognitionStage.formattingIngredients.rawValue
                }
            }

            self?.processVisionText()
        }
    }
}

// MARK: - Vision Image-to-Text Recognition Handlers
extension IngredientRecognitionHandler {
    /// This will be performed on a background thread. For some reason the recognition
    /// is not marked as an async function so we don't use the async-await syntax here.
    private func performImageToTextRecognition(on image: UIImage,
                                               in region: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)) throws {
        guard let cgImage = image.cgImage else {
            throw IngredientRecognitionError.undefinedImage
        }

        print("Starting performImagetoTextRecognition.")
        print("Current Thread: \(Thread.current)\n")

        let myImageTextRequest = VNImageRequestHandler(cgImage: cgImage, orientation: .right)

        /*
         VNRecognizeTextRequest provides text-recognition capabilities.
         The default is the "accurate" method which does neural-network based text detection and recognition.
         It is slower but more accurate.
         */
        let request = VNRecognizeTextRequest(completionHandler: formatObservations)
        request.recognitionLevel = .accurate
        request.regionOfInterest = region

        // For consistency, use revision 3 of the model.
        request.revision = 3
        // Prefer processing in the background.
        request.preferBackgroundProcessing = true

        do {
            print("Will try performing the recognize text request.")
            print("Current Thread: \(Thread.current)")
            try myImageTextRequest.perform([request])
        } catch {
            print("Something went wrong: \(error.localizedDescription)")
            throw error
        }

        print("Exiting performImagetoTextRecognition.\n")
    }

    /// Completion handler for the image text recognition request.
    /// This will process the response and return an array of the results.
    private func formatObservations(request: VNRequest, error: Error?) {
        // Retrieve the results of the request, which is an array of VNRecognizedTextObservation objects.
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        print("Starting formatObservations.")
        print("Current Thread: \(Thread.current). Should not be main.\n")

        let results = observations.compactMap { observation in
            // topCandidates returns an array of the top n candidates as VNRecognizedText objects.
            // Then we use [0] to get that top candidate.
            // Then we access the string parameter, which is the text as a String type.
            // The resulting type of results is then [String].

            return observation.topCandidates(1)[0].string
        }

        print("Setting lastResultsFromVision.\n")
        lastResultsFromVision = results

        print("Exiting formatObservations.\n")
    }

    public func convertBoundingBoxToNormalizedBoxForVisionROI(
        boxLocation: CGPoint, boxSize: CGSize, imageSize: CGSize) -> CGRect {
            /// Calculates the size of the region of interest normalized to the size of the input image.
            let normalizedWidth = boxSize.width / imageSize.width
            let normalizedHeight = boxSize.height / imageSize.height
            //        print("normal izedWidth: \(normalizedWidth), normalizedHeight: \(normalizedHeight)")

            /// Now calculate the x and y coordinate of the region of interest assuming the lower
            /// left corner is the origin rather than the top left corner of the image.
            /// The origin of the bounding box is in its top leading corner. So the x
            /// is the same for the unnormalized and normalized regions.
            /// For y, we need to calculate the
            /// normalized coordinate of the lower left corner.
            let newOriginX = max(boxLocation.x, 0)
            let newOriginY = max(imageSize.height - (boxLocation.y + boxSize.height), 0)
            //        print("newOriginX: \(newOriginX), newOriginY: \(newOriginY)")

            /// Normalize the new origin to the size of the input image.
            let normalizedOriginX = newOriginX / imageSize.width
            let normalizedOriginY = newOriginY / imageSize.height
            //        print("normalizedOriginX: \(normalizedOriginX), normalizedOriginY: \(normalizedOriginY)")

            let finalROICGRect = CGRect(
                x: normalizedOriginX, y: normalizedOriginY,
                width: normalizedWidth, height: normalizedHeight
            )
            //        print("final CGRect: \(finalROICGRect)")
            return finalROICGRect
        }
}

// MARK: - ChatGPT Ingredient Parsing and Formatting
extension IngredientRecognitionHandler {
    /// Processes text that was output from Vision.
    public func processVisionText() {
        print("Starting processVisionText\n")

        guard let ingredients = lastResultsFromVision?.joined(separator: " ") else {
            print("lastResultsFromVision was empty. Exiting processVisionText")

            DispatchQueue.main.async { [weak self] in
                print("Current Thread: \(Thread.current)")
                withAnimation {
                    self?.progressStage = "lastResultsFromVision was empty."
                }
            }
            return
        }

        let content = separateIngredientsCompletion + "\"\(ingredients)\""

        /// Construct the input and make the call to ChatGPT.
        let message = Message(role: "system", content: content)
        let requestObject = CompletionRequest(
            model: Chat.chatgpt.rawValue, maxTokens: 1000,
            messages: [message], temperature: 0.7, stream: false
        )

        openAIManager.postMessageToCompletionsEndpoint(
            requestObject: requestObject) { [weak self] openAIResponse, error in

                guard error == nil else {
                    print("An Error occurred: \(error!)")
                    return
                }

                guard let openAIResponse = openAIResponse else {
                    print("OpenAIResponse was nil.\n")
                    DispatchQueue.main.async {
                        self?.progressStage = IngredientRecognitionStage.formattingError.rawValue
                    }
                    return
                }

                let ingredientJSONString = openAIResponse.choices[0].message.content

                /// Try to convert the JSON string from ChatGPT into a JSON Data object.
                guard let ingredientJSON = ingredientJSONString.data(using: .utf8) else {
                    print("Could not cast ingredientJSONString as JSON Object.\n")
                    DispatchQueue.main.async {
                        self?.progressStage = IngredientRecognitionStage.formattingError.rawValue
                    }
                    return
                }

                /// Try to decode the JSON object into a DecodedIngredients object.
                guard let ingredientsObj = try? JSONDecoder().decode(DecodedIngredients.self, from: ingredientJSON) else {
                    print("Could not decode ingredientJSON to DecodedIgredients.\n")
                    DispatchQueue.main.async {
                        self?.progressStage = IngredientRecognitionStage.formattingError.rawValue
                    }
                    return
                }

                self?.lastIngredientGroupFromChatGPT = ingredientsObj

                DispatchQueue.main.async {
                    print("Setting progressMessage to done")
                    print("Current Thread: \(Thread.current)")
                    self?.progressStage = IngredientRecognitionStage.done.rawValue
                    self?.recognitionInProgress = false

                    if self?.lastIngredientGroupFromChatGPT != nil {
                        self?.presentNewIngredients = true
                        print("new ingredients available")
                    } else {
                        //                self?.progressMessage = RecognitionProgressMessages.error.rawValue
                    }
                }
            }

        print("Exiting processVisionText")
    }
}
