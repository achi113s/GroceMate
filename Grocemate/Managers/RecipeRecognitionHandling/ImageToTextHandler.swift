//
//  ImageToTextHandler2.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/13/24.
//

import SwiftUI
import Vision

final class ImageToTextHandler: ImageToTextHandling {
    public var recognitionLevel: VNRequestTextRecognitionLevel
    public var revision: Int
    public var preferBackgroundProcessing: Bool

    init(recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
         revision: Int = 3,
         preferBackgroundProcessing: Bool = true) {
        self.recognitionLevel = recognitionLevel
        self.revision = revision
        self.preferBackgroundProcessing = preferBackgroundProcessing
    }

    /// Performs text recognition on an input image and then
    /// executes the provided completion handler.
    public func performImageToTextRecognition(
        on image: UIImage,
        with orientation: CGImagePropertyOrientation = .right,
        in region: CGRect,
        _ completion: @escaping (_: VNRequest, _: Error?) -> Void) {
            guard let cgImage = image.cgImage else {
                completion(VNRequest(), ImageRecognitionError.badImage)
                return
            }

            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation)

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
                completion(textRecognitionRequest, ImageRecognitionError.textRecognitionError)
                return
            }
        }
}
