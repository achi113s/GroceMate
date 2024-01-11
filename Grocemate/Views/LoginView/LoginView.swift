//
//  LoginView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/10/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Grocemate")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            .foregroundStyle(.blue)

            Spacer()

            Button {
                print("sign in with apple pressed")
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
