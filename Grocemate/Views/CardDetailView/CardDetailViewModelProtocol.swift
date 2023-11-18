//
//  CardDetailViewModelProtocol.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import SwiftUI

protocol CardDetailViewModel: ObservableObject {
    var editMode: EditMode { get set }
    var titleError: Bool { get set }
    var ingredientsError: Bool { get set }
    
    var card: IngredientCard { get set }
    var ingredients: [Ingredient] { get set }
    
    func addIngredient()
    func addIngredientsToCard()
    func deleteIngredient(_ indexSet: IndexSet)
    func save() throws
}
