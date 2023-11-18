//
//  HomeViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/17/23.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var path = NavigationPath()
    
    @Published var sheet: Sheets?
    
    @Published var presentCreateCardView: Bool = false
    @Published var presentConfirmationDialog: Bool = false
    @Published var presentPhotosPicker: Bool = false
    @Published var presentRecognitionInProgress: Bool = false
    
    @Published var selectedCard: IngredientCard?
}
