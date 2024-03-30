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

struct DecodedRecipe: Codable, Equatable {
    let ingredients: [String]
    let yield: String
    let title: String
    let steps: [String]
    let notes: String
}
