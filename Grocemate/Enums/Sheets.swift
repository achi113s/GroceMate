//
//  Sheets.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import Foundation

public enum Sheets: String, Identifiable {
    case imageROI, editCard, manuallyCreateCard, documentScanner
    public var id: String { rawValue }
}
