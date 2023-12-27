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
        HStack(spacing: 15) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 24, weight: .semibold))

            Text("\(ingredientRecognitionHandler.progressStage)")
                .font(.system(size: 17, weight: .semibold, design: .rounded))

            Button {
                ingredientRecognitionHandler.recognitionInProgress.toggle()
            } label: {
                Text("Dismiss")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
        }
        .opacity(animate ? 1.0 : 0.2)
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(radius: 4)
                .frame(maxWidth: .greatestFiniteMagnitude)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                animate.toggle()
            }
        }
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
    }
}

#Preview {
    RecognitionInProgressToast()
        .environmentObject(IngredientRecognitionHandler(openAIManager: OpenAIManager()))
}
