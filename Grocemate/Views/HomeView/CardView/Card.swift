//
//  Card.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import CoreData
import SwiftUI

struct Card: View {
    // MARK: - Environment
    @EnvironmentObject var hapticEngine: HapticEngine
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var homeViewModel: HomeViewModel

    // MARK: - State
    @ObservedObject var ingredientCard: IngredientCard
    @GestureState private var cardLongPressGestureState = CardLongPressGestureState.inactive

    // MARK: - Properties
    private let cardPressedScale: CGSize = CGSize(width: 0.97, height: 0.97)
    private let minimumLongPressDuration: CGFloat = 1.0
    private let pressedAnimationDuration: CGFloat = 0.2

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            cardTitleView
            ingredientsView
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 30)
        .mask {
            RoundedRectangle(cornerRadius: 25)
        }
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .shadow(radius: 4)
                .frame(maxWidth: .infinity)
        }
        .gesture(cardLongPressGesture)
        .scaleEffect(
            self.cardLongPressGestureState.isLongPressing ? cardPressedScale : CGSize(width: 1.0, height: 1.0),
            anchor: .center
        )
        .animation(
            .interpolatingSpring(stiffness: 300, damping: 10),
            value: self.cardLongPressGestureState.isLongPressing
        )
    }

    init(ingredientCard: IngredientCard) {
        self._ingredientCard = ObservedObject(initialValue: ingredientCard)
    }

    // MARK: - Subviews
    private var cardTitleView: some View {
        Text(ingredientCard.title)
            .font(.system(size: 24))
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }

    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(ingredientCard.ingredientsArr) { ingredient in
                HStack(alignment: .center) {
                    SwipeableIngredient(ingredient: ingredient)
//                            .textColor(Color("AccentColor"))
//                            .strikethroughColor(Color("AccentColor"))
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private enum CardLongPressGestureState {
        case inactive
        case pressing
        case finishedLongPress

        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .finishedLongPress:
                return true
            }
        }

        var isLongPressing: Bool {
            switch self {
            case .inactive, .finishedLongPress:
                return false
            case .pressing:
                return true
            }
        }
    }

    private var cardLongPressGesture: some Gesture {
        LongPressGesture(minimumDuration: minimumLongPressDuration)
            .updating($cardLongPressGestureState, body: { _, gestureState, _ in
                gestureState = .pressing
            })
            .onEnded { _ in
                hapticEngine.playHaptic(.longPressSuccess)
                /// This is the only reason we need the main view model in the environment.
                /// Maybe there is a better way to show a confirmation dialog and
                /// keep track of the selected ingredient card? This method
                /// introduces a bit of coupling between Card and HomeView.
                homeViewModel.presentConfirmationDialog = true
                homeViewModel.selectedCard = ingredientCard
            }
    }
}

#Preview {
    Card(ingredientCard: .preview())
}
