//
//  CardDetailViewModelProtocol.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import SwiftUI

protocol CardDetailViewModellable: ObservableObject {
    var editMode: EditMode { get set }
    var titleError: Bool { get set }
    var ingredientsError: Bool { get set }

    var card: IngredientCard { get set }
    var title: String { get set }
    var ingredients: [Ingredient] { get set }

    func clearTitle()
    func addDummyIngredient()
    func setCardTitle()
    func setIngredientsToCard()
    func deleteIngredient(_ indexSet: IndexSet)
    func save() throws
    func titleErrorAnimation()
    func ingredientsErrorAnimation()
}
