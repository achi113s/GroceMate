//
//  RubberBanding.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/3/23.
//

import Foundation

/// Rubber banding formula from iOS 6.
struct RubberBanding {
    static func rubberBanding(
        offset: CGFloat,
        distance: CGFloat,
        coefficient: CGFloat
    ) -> CGFloat {
        (1.0 - (1.0 / ((offset * coefficient / distance) + 1.0))) * distance
    }
}
