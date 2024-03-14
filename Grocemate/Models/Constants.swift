//
//  K.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

class Constants {
    static let textRecognitionSessionQueueName: String = "com.grocemate.recognitionQueue"
    static let recipeRecognitionSessionQueue: String = "com.grocemate.recipeRecognitionQueue"

    static let separateIngredientsPrompt = """
         Separate this ingredient list into an array of strings of its
         components and output as a JSON object. The JSON object should
         have the following format: {"ingredients": []}.
         Here are the ingredients:
    """
}
