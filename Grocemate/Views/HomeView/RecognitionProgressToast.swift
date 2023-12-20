//
//  RecognitionProgressToast.swift
//  Grocemate
//
//  Created by Giorgio Latour on 12/20/23.
//

import SwiftUI

struct RecognitionInProgressToast: View {
    @EnvironmentObject var ingredientRecognitionHandler: IngredientRecognitionHandler

    @State private var animate: Bool = false

    var body: some View {
        VStack {
            Text("\(ingredientRecognitionHandler.progressStage)")
//            Text("Recognition in Progress")
                .opacity(animate ? 1.0 : 0.2)

            Button {
                ingredientRecognitionHandler.recognitionInProgress.toggle()
            } label: {
                Text("Dismiss")
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 30)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 4)
                .frame(maxWidth: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    RecognitionInProgressToast()
        .environmentObject(IngredientRecognitionHandler(openAIManager: OpenAIManager()))
}
