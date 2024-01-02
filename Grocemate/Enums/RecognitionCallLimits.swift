//
//  RecognitionLimits.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/1/24.
//

import Foundation

enum RecognitionCallLimits {
    case numberOfRecognitionCallsThisPeriod, lastResetDate

    var userDefaultsKey: String {
        switch self {
        case .numberOfRecognitionCallsThisPeriod:
            return "numberOfRecognitionCallsThisPeriod"
        case .lastResetDate:
            return "lastResetDate"
        }
    }
}
