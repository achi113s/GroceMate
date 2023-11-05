//
//  ContentView.swift
//  GroceMate
//
//  Created by Giorgio Latour on 11/2/23.
//

import SwiftUI

struct ContentView: View {
//    @State private var testCard = IngredientCard(
//        name: "Green Tea Ice Cream",
//        ingredients: [
//            Ingredient("1 cup (250ml) whole milk"),
//            Ingredient("3/4 cup (150g) sugar"),
//            Ingredient("pinch of kosher or sea salt"),
//            Ingredient("2 cups (500ml) heavy cream"),
//            Ingredient("4 teaspoons matcha (green tea powder)"),
//            Ingredient("6 large egg yolks")
//        ]
//    )
    
    @FetchRequest(fetchRequest: IngredientCard.all()) private var ingredientCards
    
    var coreDataController = CoreDataController.shared
    
    @State private var showCreateCardView: Bool = false
    
    var body: some View {
        ZStack {
            Button {
                showCreateCardView = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.blue)
                        .frame(width: 120, height: 50)
                    Text("Grocemate")
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
            }
            .tint(.white)
            
            ScrollView(.vertical) {
                VStack {
                    if ingredientCards.isEmpty {
                        Text("Tap the camera icon to get started!")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
//                                .foregroundColor(Color("AccentColor"))
                            .frame(width: 300) // Make the scroll view full-width
                            .frame(minHeight: 600) // Set the content’s min height to the parent.
                    } else {
                        LazyVStack(alignment: .center) {
                            ForEach(ingredientCards) { ingredientCard in
                                Card(ingredientCard: ingredientCard)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateCardView, content: {
            CreateCardView(vm: .init(coreDataController: .shared))
        })
    }
}

#Preview {
    ContentView()
}
