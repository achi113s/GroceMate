//
//  ImageToTextHandling.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import SwiftUI
import Vision

protocol ImageToTextHandling: ObservableObject {
    var recognitionLevel: VNRequestTextRecognitionLevel { get set }
    var revision: Int { get set }
    var preferBackgroundProcessing: Bool { get set }

    func performImageToTextRecognition(on image: UIImage, with orientation: CGImagePropertyOrientation,
                                       in region: CGRect,
                                       _ completion: @escaping (_: VNRequest, _: Error?) -> Void)
}
