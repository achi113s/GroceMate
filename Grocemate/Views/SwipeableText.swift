//
//  SwipeableText.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import CoreHaptics
import SwiftUI

struct SwipeableText: View {
//    @EnvironmentObject var myHapticEngine: MyHapticEngine
    @Environment(\.managedObjectContext) private var moc
    
    //MARK: - State
    /// Should the text be strikethrough already?
//    @Binding private var isMarkedComplete: Bool
    @ObservedObject private var ingredient: Ingredient
    
    /// Use this to animated the strikethrough as you pull the text.
    @State private var progress: CGFloat = 0.0
    @State private var offset: CGSize = .zero
    
    //MARK: - Properties
    private var text: String
    private var textColor: Color = .black
    private var strikethroughColor: Color = .black
    
//    init(complete isMarkedComplete: Binding<Bool>, text: String, ingredient: ObservedObject<Ingredient>) {
//        self._isMarkedComplete = isMarkedComplete
//        self.text = text
//        self._ingredient = ingredient
//    }
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        self.text = ingredient.name
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
                    swipeToCompleteGesture
                )
        }
    }
    
    public func textColor(_ color: Color) -> SwipeableText {
        var view = self
        view.textColor = color
        return view
    }
    
    public func strikethroughColor(_ color: Color) -> SwipeableText {
        var view = self
        view.strikethroughColor = color
        return view
    }
    
    private var swipeToCompleteGesture: some Gesture {
        DragGesture()
            .onChanged { dragValue in
                /// Only allow dragging from right to left.
                guard dragValue.translation.width > 0 else { return }
                
                /// Rubber banding effect for the drag.
                let dragLimit: CGFloat = 100
//                let factor = 1 / (dragValue.translation.width / limit + 1)
//                self.offset.width = dragValue.translation.width * factor
                let rubberBanded: CGFloat = RubberBanding.rubberBanding(
                    offset: dragValue.translation.width,
                    distance: dragValue.translation.width,
                    coefficient: 0.4
                )
                
                self.offset.width = min(rubberBanded, dragLimit)
                
                
//                if !self.isMarkedComplete {
//                    self.progress = self.offset.width / dragLimit
//                }
                
                if !self.ingredient.complete {
                    self.progress = self.offset.width / dragLimit
                }
            }
            .onEnded { dragValue in
                // If full drag was completed, toggle complete and
                // set strikethrough accoordingly.
                if self.offset.width > 50 {
                    withAnimation(.easeInOut) {
//                        isMarkedComplete.toggle()
                        toggleIngredientCompleted()
                        
//                        if self.isMarkedComplete {
//                            self.progress = 1.0
//                        } else {
//                            self.progress = 0.0
//                        }
                        
                        if self.ingredient.complete {
                            self.progress = 1.0
                        } else {
                            self.progress = 0.0
                        }
                        
//                        myHapticEngine.playHaptic(.simpleSuccess)
                    }
                } else {
                    /*
                     If the full drag wasn't completed and the item
                     is not completed, set strikethrough progress
                     back to zero.
                     */
//                    if !isMarkedComplete {
//                        withAnimation(.easeInOut) {
//                            self.progress = 0.0
//                        }
//                    }
                    if !self.ingredient.complete {
                        withAnimation(.easeInOut) {
                            self.progress = 0.0
                        }
                    }
                }
                
                // Always return the text back to its original
                // location.
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.offset.width = .zero
                }
            }
    }
}

extension SwipeableText {
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
//#Preview {
//    SwipeableText(complete: .constant(true), text: "Hello, World!")
//}
