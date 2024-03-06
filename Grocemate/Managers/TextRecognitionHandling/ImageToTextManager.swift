//
//  ImageToTextManager.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/6/24.
//

import SwiftUI
import Vision

final class ImageToText: ObservableObject {
    /// This will be performed on a background thread. For some reason the recognition
    /// is not marked as an async function so we don't use the async-await syntax here.
    private func performImageToTextRecognition(on image: UIImage,
                                               in region: CGRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)) throws {
        guard let cgImage = image.cgImage else {
            throw URLError(.badURL)
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

        print(results.joined(separator: " "))
        print("Exiting formatObservations.\n")
    }
}
