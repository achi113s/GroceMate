//
//  Sheets.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/18/23.
//

import Foundation

public enum Sheets: String, Identifiable {
    case cameraView, imageROI, editCard, manuallyCreateCard
    public var id: String { rawValue }
}
