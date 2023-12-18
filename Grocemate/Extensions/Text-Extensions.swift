//
//  Text-Extensions.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import SwiftUI

extension Text {
    /// Both of these work by overlaying a strikethrough with clear text
    /// over the existing text, allowing you to animate the strikethrough.
    func animatedStrikethrough(_ isActive: Bool = true,
                               pattern: Text.LineStyle.Pattern = .solid,
                               textColor: Color? = nil,
                               color: Color? = nil) -> some View {
        self
            .foregroundColor(textColor)
            .overlay(alignment: .leading) {
                self
                    .foregroundColor(.clear)
                    .strikethrough(isActive, color: color)
                    .scaleEffect(x: isActive ? 1 : 0, anchor: .leading)
            }
    }

    /// This version allows you bind to an external progress
    /// indicator, so you can do things like animate the strikethrough as the user
    /// completes a gesture.
    func animatedStrikethroughWithProgress(_ progress: CGFloat = 0,
                                           pattern: Text.LineStyle.Pattern = .solid,
                                           textColor: Color? = nil,
                                           color: Color? = nil) -> some View {
        self
            .foregroundColor(textColor)
            .overlay(alignment: .leading) {
                self
                    .foregroundColor(.clear)
                    .strikethrough(true, color: color)
                    .scaleEffect(x: progress, anchor: .leading)
            }
    }
}
