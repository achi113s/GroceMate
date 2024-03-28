//
//  DecodedRecipe.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/19/24.
//

import Foundation

struct DecodedIngredients: Codable {
    let ingredients: [String]
}

struct DecodedRecipe: Codable {
    let ingredients: [String]
    let title: String
    let steps: [String]
    let notes: String
}
