//
//  Card.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import SwiftUI

//struct Card: View {
//    //MARK: - Environment
//    @EnvironmentObject var hapticEngine: HapticEngine
//    //    @EnvironmentObject var viewModel: MainViewModel
//    
//    //MARK: - State
////    @ObservedObject var ingredientCard: IngredientCard
//    
//    @GestureState private var cardLongPressGestureState = CardLongPressGestureState.inactive
//
//    //MARK: - Properties
//    private let cardPressedScale: CGSize = CGSize(width: 0.97, height: 0.97)
//    private let minimumLongPressDuration: CGFloat = 1.0
//    private let pressedAnimationDuration: CGFloat = 0.2
//    
//    private var cardLongPressGesture: some Gesture {
//        LongPressGesture(minimumDuration: minimumLongPressDuration)
//            .updating($cardLongPressGestureState, body: { currentState, gestureState, transaction in
//                gestureState = .pressing
//            })
//            .onEnded { finished in
//                hapticEngine.playHaptic(.longPressSuccess)
//                //                viewModel.presentConfirmationDialog = true
//                //                viewModel.selectedIngredientCard = ingredientCard
//            }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 15) {
////            Text(ingredientCard.name)
////                .font(.system(size: 24, weight: .semibold, design: .rounded))
////            VStack(alignment: .leading, spacing: 10) {
////                ForEach(ingredientCard.ingredients, id: \.id) { ingredient in
////                    HStack(alignment: .center) {
////                        SwipeableText(
////                            complete: $ingredientCard.ingredients[ingredientCard.ingredients.firstIndex(of: ingredient)!].complete,
////                            text: ingredient.name)
////                        //                        .textColor(Color("AccentColor"))
////                        //                        .strikethroughColor(Color("AccentColor"))
////                        .font(.system(size: 17, weight: .semibold, design: .rounded))
////                    }
////                }
////            }
////            .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding(.vertical, 15)
//        .padding(.horizontal, 30)
//        .mask {
//            RoundedRectangle(cornerRadius: 25)
//        }
//        .background {
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color.white)
//                .shadow(radius: 4)
//                .frame(maxWidth: .infinity)
//        }
//        .gesture(cardLongPressGesture)
//        .scaleEffect(self.cardLongPressGestureState.isLongPressing ? cardPressedScale : CGSize(width: 1.0, height: 1.0), anchor: .center)
//        .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: self.cardLongPressGestureState.isLongPressing)
//    }
//    
//    init(ingredientCard: IngredientCard) {
//        self._ingredientCard = ObservedObject(initialValue: ingredientCard)
//    }
//    
//    private enum CardLongPressGestureState {
//        case inactive
//        case pressing
//        case finishedLongPress
//        
//        var isActive: Bool {
//            switch self {
//            case .inactive:
//                return false
//            case .pressing, .finishedLongPress:
//                return true
//            }
//        }
//        
//        var isLongPressing: Bool {
//            switch self {
//            case .inactive, .finishedLongPress:
//                return false
//            case .pressing:
//                return true
//            }
//        }
//    }
//}
//
////#Preview {
////    Card(ingredientCard:
////        IngredientCard(
////            name: "Green Tea Ice Cream",
////            ingredients: [
////                Ingredient("1 cup (250ml) whole milk"),
////                Ingredient("3/4 cup (150g) sugar"),
////                Ingredient("pinch of kosher or sea salt"),
////                Ingredient("2 cups (500ml) heavy cream"),
////                Ingredient("4 teaspoons matcha (green tea powder)"),
////                Ingredient("6 large egg yolks")
////            ]
////        )
////    ))
////}
