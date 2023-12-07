//
//  SwipeableText.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import CoreHaptics
import SwiftUI

struct SwipeableIngredient: View {
    @EnvironmentObject var hapticEngine: HapticEngine
    @Environment(\.managedObjectContext) private var moc

    // MARK: - State
    @ObservedObject private var ingredient: Ingredient

    /// Use this to animate the strikethrough as you pull the text.
    @State private var progress: CGFloat
    @State private var offset: CGSize = .zero

    // MARK: - Properties
    private var text: String
    private var textColor: Color = .black
    private var strikethroughColor: Color = .black

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        self.text = ingredient.name

        if ingredient.complete {
            self.progress = 1.0
        } else {
            self.progress = 0.0
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(ingredient.name)
                .animatedStrikethroughWithProgress(
                    progress,
                    textColor: textColor,
                    color: strikethroughColor
                )
                .offset(offset)
                .gesture(
                    swipeToStrikethroughGesture
                )
        }
    }

    // MARK: - Public View Modifiers
    public func textColor(_ color: Color) -> SwipeableIngredient {
        var view = self
        view.textColor = color
        return view
    }

    public func strikethroughColor(_ color: Color) -> SwipeableIngredient {
        var view = self
        view.strikethroughColor = color
        return view
    }

    private var swipeToStrikethroughGesture: some Gesture {
        DragGesture()
            .onChanged { dragValue in
                /// Only allow dragging from right to left.
                guard dragValue.translation.width > 0 else { return }

                /// Rubber banding effect for the drag.
                let dragLimit: CGFloat = 100
                let rubberBanded: CGFloat = RubberBanding.rubberBanding(
                    offset: dragValue.translation.width,
                    distance: dragValue.translation.width,
                    coefficient: 0.4
                )

                self.offset.width = min(rubberBanded, dragLimit)

                if !self.ingredient.complete {
                    self.progress = self.offset.width / dragLimit
                }
            }
            .onEnded { _ in
                /// If full drag was completed, toggle complete and
                /// set strikethrough accoordingly.
                if self.offset.width > 50 {
                    withAnimation(.easeInOut) {

                        toggleIngredientCompleted()

                        if self.ingredient.complete {
                            self.progress = 1.0
                        } else {
                            self.progress = 0.0
                        }

//                        hapticEngine.playHaptic(.swipeSuccess)
                        hapticEngine.asyncPlayHaptic(.swipeSuccess)
                    }
                } else {
                    /// If the full drag wasn't completed and the item
                    /// is not completed, set strikethrough progress
                    /// back to zero.
                    if !self.ingredient.complete {
                        withAnimation(.easeInOut) {
                            self.progress = 0.0
                        }
                    }
                }

                /// Always return the text back to its original location.
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.offset.width = .zero
                }
            }
    }
}

extension SwipeableIngredient {
    /// Toggle completed on the ingredient object.
    func toggleIngredientCompleted() {
        ingredient.complete.toggle()
        do {
            if moc.hasChanges {
                try moc.save()
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    SwipeableIngredient(ingredient: .preview())
}
