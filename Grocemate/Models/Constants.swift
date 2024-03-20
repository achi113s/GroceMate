//
//  Constants.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/18/23.
//

import Foundation

class Constants {
    static let textRecognitionSessionQueueName: String = "com.grocemate.recognitionQueue"
    static let recipeRecognitionSessionQueue: String = "com.grocemate.recipeRecognitionQueue"

    static let separateIngredientsPrompt = """
    Separate this ingredient list into an array of strings of its \
    components and output as a JSON object. The JSON object should \
    have the following format: {"ingredients": []}. \
    Here are the ingredients:
    """

    static let recipePrompt = """
    Partition this food recipe into a JSON object which includes \
    properties for the title (as a string), the individual recipe \
    steps (as an array of strings), and the ingredients (as array \
    of strings). There may be some portion of the recipe that includes \
    a narrative description of the recipe, food pairing suggestions, or \
    other text not directly related to the recipe instructions. \
    You can put all of that into the notes field (as a string). The JSON \
    object should have the following format: {"title": "", "steps": [], \
    "ingredients": [], "notes": ""}. Here is the recipe:
    """
}
