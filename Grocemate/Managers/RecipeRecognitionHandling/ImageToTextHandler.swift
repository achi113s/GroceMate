//
//  AsyncAwaitImageToTextManager.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/6/24.
//

import SwiftUI
import Vision

enum ImageRecognitionError: Error {
    case badImage, textRecognitionError, resultsTypeCastError
}

struct ImageToTextHandlerAsyncAwait {
    public var recognitionLevel: VNRequestTextRecognitionLevel
    public var revision: Int
    public var imageOrientation: CGImagePropertyOrientation
    public var preferBackgroundProcessing: Bool

    init(recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
         revision: Int = 3,
         imageOrientation: CGImagePropertyOrientation = .right, 
         preferBackgroundProcessing: Bool = true) {
        self.recognitionLevel = recognitionLevel
        self.revision = revision
        self.imageOrientation = imageOrientation
        self.preferBackgroundProcessing = preferBackgroundProcessing
    }

    /// Performs text recognition on an input image and then
    /// executes the provided completion handler.
    private func performImageToTextRecognition(
        on image: UIImage,
        in region: CGRect,
        _ completion: @escaping (_: VNRequest, _: Error?) -> Void) {
            guard let cgImage = image.cgImage else {
                completion(VNRequest(), ImageRecognitionError.badImage)
                return
            }

            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: self.imageOrientation)

            /*
             VNRecognizeTextRequest provides text-recognition capabilities.
             The default is the "accurate" method which does neural-network
             based text detection and recognition. It is slower but more accurate.
             */
            let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: completion)
            textRecognitionRequest.recognitionLevel = self.recognitionLevel
            textRecognitionRequest.regionOfInterest = region

            textRecognitionRequest.revision = self.revision
            textRecognitionRequest.preferBackgroundProcessing = self.preferBackgroundProcessing

            do {
                try imageRequestHandler.perform([textRecognitionRequest])
            } catch {
                completion(VNRequest(), ImageRecognitionError.textRecognitionError)
                return
            }
        }

    /// Public, async, throwing method for getting text from an image. Uses Vision's
    /// VNRecognizeText request and asynchronously returns an array of strings.
    public func getTextFromImage(
        _ image: UIImage,
        in region: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            performImageToTextRecognition(on: image, in: region) { request, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: ImageRecognitionError.resultsTypeCastError)
                    return
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

                continuation.resume(returning: results)
            }
        }
    }
}
