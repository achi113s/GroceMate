//
//  SignInWithAppleUIKit.swift
//  Grocemate
//
//  Created by Giorgio Latour on 1/10/24.
//

import AuthenticationServices
import SwiftUI

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton

    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}
