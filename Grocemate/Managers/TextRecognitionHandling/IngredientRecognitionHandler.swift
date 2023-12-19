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
    let textRecognitionSessionQueue = DispatchQueue(label: K.textRecognitionSessionQueueName, qos: .background)

    @Published var progressStage: IngredientRecognitionStage = .done
    @Published var recognitionInProgress: Bool = false
    @Published var presentNewIngredients: Bool = false

    private var lastResultsFromVision: [String]? = nil
    private var lastResponseFromChatGPT: OpenAIResponse? = nil
    public var lastIngredientGroupFromChatGPT: DecodedIngredients? = nil

    private let separateIngredientsCompletion = """
         Separate this ingredient list into an array of strings of its
         components and output as a JSON object. The JSON object should
         have the following format: {"ingredients": []}.
         Here are the ingredients:
        """

    private var openAIManager: OpenAIManageable

    init(openAIManager: OpenAIManageable) {
        self.openAIManager = openAIManager
    }

    /// The public function for performing ingredients in an image.
    public func recognizeIngredientsInImage(image: UIImage, region: CGRect) {
        /// Move to the textRecognitionSessionQueue for the text recognition with Vision.
        textRecognitionSessionQueue.async { [weak self] in
            /// First set these two progress variables on main thread.
            DispatchQueue.main.async {
                print("Setting recognitionInProgress to true and setting progressMessage")
                print("Current Thread: \(Thread.current)")
                self?.recognitionInProgress = true
                self?.progressStage = .startingVision
            }

            self?.performImageToTextRecognition(on: image, in: region)
        }

        /// A second async block for the ChatGPT API call.
        textRecognitionSessionQueue.async { [weak self] in
            DispatchQueue.main.async {
                print("Setting progressMessage to parsing ingredients")
                print("Current Thread: \(Thread.current)")
                self?.progressStage = .parsingIngredients
            }

            self?.processVisionText()
        }
    }
}

//MARK: - Vision Image-to-Text Recognition Handlers
extension IngredientRecognitionHandler {
    /// This will be performed on a background thread. For some reason the recognition
    /// is not marked as an async function so we don't use the async-await syntax here.
    private func performImageToTextRecognition(on image: UIImage,
                                               in region: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)) {
        guard let cgImage = image.cgImage else { return }

        print("Starting performImagetoTextRecognition.")
        print("Current Thread: \(Thread.current)")

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
            DispatchQueue.main.async { [weak self] in
                self?.progressStage = .error
            }
        }

        print("Exiting performImagetoTextRecognition")
    }

    /// Completion handler for the image text recognition request.
    /// This will process the response and return an array of the results.
    private func formatObservations(request: VNRequest, error: Error?) {
        // Retrieve the results of the request, which is an array of VNRecognizedTextObservation objects.
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

        print("Starting formatObservations.")
        print("Current Thread: \(Thread.current). Should not be main.")

        let results = observations.compactMap { observation in
            // topCandidates returns an array of the top n candidates as VNRecognizedText objects.
            // Then we use [0] to get that top candidate.
            // Then we access the string parameter, which is the text as a String type.
            // The resulting type of results is then [String].

            return observation.topCandidates(1)[0].string
        }

        print("Setting lastResultsFromVision.")
        lastResultsFromVision = results

        print("Exiting formatObservations.")
    }

    public func convertBoundingBoxToNormalizedBoxForVisionROI(boxLocation: CGPoint, boxSize: CGSize, imageSize: CGSize) -> CGRect {
        // Calculate the size of the region of interest normalized to the size of the input image.
        let normalizedWidth = boxSize.width / imageSize.width
        let normalizedHeight = boxSize.height / imageSize.height
        print("normalizedWidth: \(normalizedWidth), normalizedHeight: \(normalizedHeight)")

        /*
         Now calculate the x and y coordinate of the region of interest assuming the lower
         left corner is the origin rather than the top left corner of the image.
         The origin of the bounding box is in its top leading corner. So the x
         is the same for the unnormalized and normalized regions.
         For y, we need to calculate the
         normalized coordinate of the lower left corner.
         */
        let newOriginX = max(boxLocation.x, 0)
        let newOriginY = max(imageSize.height - (boxLocation.y + boxSize.height), 0)
        print("newOriginX: \(newOriginX), newOriginY: \(newOriginY)")

        // Now normalize the new origin to the size of the input image.
        let normalizedOriginX = newOriginX / imageSize.width
        let normalizedOriginY = newOriginY / imageSize.height
        print("normalizedOriginX: \(normalizedOriginX), normalizedOriginY: \(normalizedOriginY)")

        let finalROICGRect = CGRect(x: normalizedOriginX, y: normalizedOriginY, width: normalizedWidth, height: normalizedHeight)
        print("final CGRect: \(finalROICGRect)")
        return finalROICGRect
    }
}

//MARK: - ChatGPT Ingredient Parsing and Formatting
extension IngredientRecognitionHandler {
    // Process text that was output from Vision.
    public func processVisionText() {
        print("Starting processVisionText")
        guard let ingredients = lastResultsFromVision?.joined(separator: " ") else {
            print("lastResultsFromVision was empty. Exiting processVisionText")
            return
        }

        let content = separateIngredientsCompletion + "\"\(ingredients)\""

        postMessageToCompletionsEndpoint(content: content, role: "system", model: Chat.chatgpt.rawValue)
        print("Exiting processVisionText")
    }

    // Post a message to OpenAI's Chat Completions API endpoint.
    private func postMessageToCompletionsEndpoint(content: String, role: String, model: String, temperature: Double = 0.7) {
//        guard let url = URL(string: openAIManager.completionsEndpoint) else {
//            print("Bad URL")
//            return
//        }
//
//        print("Starting postMessageToCompletionsEndpoint")
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        let message = Message(role: role, content: content)
//        let requestObject = CompletionRequest(model: model, max_tokens: 1000, messages: [message], temperature: temperature, stream: false)
//        let requestData = try? JSONEncoder().encode(requestObject)
//        request.httpBody = requestData

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let responseObject = try JSONDecoder().decode(OpenAIResponse.self, from: data)

                    self?.lastResponseFromChatGPT = responseObject
                    print("set lastResponseFromChatGPT")
                } catch {
                    print("There was an error decoding the JSON object: \(error.localizedDescription)")
                }
            }

            do {
                try self?.convertOpenAIResponseToIngredients()
            } catch {
                print("\(error.localizedDescription)")
            }
        }

        task.resume()
        print("Exiting postMessageToCompletionsEndpoint")
    }

    private func convertOpenAIResponseToIngredients() throws {
        guard let response = lastResponseFromChatGPT else {
            print("last response was nil")
            return
        }

        let ingredientJSONString = response.choices[0].message.content

        // Try to convert the JSON string from ChatGPT into a JSON Data object.
        guard let ingredientJSON = ingredientJSONString.data(using: .utf8) else { throw OpenAIError.badJSONString }

        // Try to decode the JSON object into a DecodedIngredients object.
        let decodedIngredientsObj = try JSONDecoder().decode(DecodedIngredients.self, from: ingredientJSON)

        lastIngredientGroupFromChatGPT = decodedIngredientsObj

        DispatchQueue.main.async { [weak self] in
            print("Setting progressMessage to done")
            print("Current Thread: \(Thread.current)")
            self?.progressMessage = RecognitionProgressMessages.done.rawValue
            self?.recognitionInProgress = false

            if self?.lastIngredientGroupFromChatGPT != nil {
                self?.presentNewIngredients = true
            } else {
                self?.progressMessage = RecognitionProgressMessages.error.rawValue
            }
        }
    }
}
