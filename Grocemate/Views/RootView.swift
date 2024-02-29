//
//  RootView.swift
//  Grocemate
//
//  Created by Giorgio Latour on 2/27/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    HomeView()
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
//            print(try? AuthenticationManager.shared.getProviders())
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SignInView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
