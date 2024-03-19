//
//  ImageRecognition-Error.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import Foundation

enum ImageRecognitionError: Error {
    case badImage, textRecognitionError, resultsTypeCastError
}
