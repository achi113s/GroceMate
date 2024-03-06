//
//  ListViewLinkButton.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/5/24.
//

import SwiftUI

struct ListViewLinkButton: View {
    private var action: () -> Void
    private var labelText: String

    init(labelText: String, action: @escaping () -> Void) {
        self.action = action
        self.labelText = labelText
    }

    var body: some View {
        Button {

        } label: {
            Button {
                action()
            } label: {
                Text(labelText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
            .accessibilityHidden(true)
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
        .accessibilityLabel(labelText)
        .accessibilityAction {
            action()
        }
    }
}
