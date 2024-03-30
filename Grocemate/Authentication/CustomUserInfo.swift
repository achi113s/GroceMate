//
//  CustomUserInfo.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/5/24.
//

import Firebase
import FirebaseAuth
import Foundation

extension User: CustomUserInfo { }

protocol CustomUserInfo {
    var uid: String { get }
    var email: String? { get }
}

struct AuthDataResultModel: CustomUserInfo {
    let uid: String
    let email: String?

    init(_ user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
