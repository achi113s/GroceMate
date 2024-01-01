//
//  TestScrollViewwithGestures.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/31/23.
//

import SwiftUI

struct TestScrollViewwithGestures: View {

    @State private var tapCount: Int = 30

    var body: some View {
        VStack {
            Text("\(tapCount) taps")
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0...100, id: \.self) { _ in
                        listItem
                            .onTapGesture { print("Tap") }
                            .simultaneousGesture(
                                LongPressGesture()
                                    .onChanged { _ in print("Long press changed") }
                                    .onEnded { _ in print("Long press ended") }
                            )
                    }
                }
            }
        }
    }

    var listItem: some View {
        Color.red
            .frame(width: 100, height: 100)
    }
}

#Preview {
    TestScrollViewwithGestures()
}
