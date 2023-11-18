//
//  Sheets.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import Foundation

enum Sheets: String, Identifiable {
    case cameraView, imageROI, ingredients
    var id: String { rawValue }
}
