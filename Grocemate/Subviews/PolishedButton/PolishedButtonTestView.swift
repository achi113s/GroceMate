//
//  CoolerButton.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/28/24.
//

import SwiftUI

struct PolishedButtonTestView: View {
    var body: some View {
        Button {

        } label: {
            Text("Default Polished")
                .font(.headline)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(15)
        }
        .buttonStyle(.polished)
        .disabled(false)

        Button {

        } label: {
            Text("Custom Polished")
                .font(.headline)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(15)
        }
        .buttonStyle(PolishedButtonStyle(cornerRadius: 10, highlightWidth: 1, color: .red))
        .foregroundStyle(.red)

        Button {

        } label: {
            Text("Polished Red Disabled")
                .font(.headline)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(15)
        }
        .buttonStyle(PolishedButtonStyle(color: .red, foregroundColor: .red))
        .disabled(true)

        Button {

        } label: {
            Text("Default Polished Disabled")
                .font(.headline)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(15)
        }
        .buttonStyle(.polished)
        .disabled(true)
    }
}

#Preview {
    PolishedButtonTestView()
}
