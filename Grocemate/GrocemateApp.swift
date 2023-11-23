//
//  GrocemateApp.swift
//  Grocemate
//
//  Created by Giorgio Latour on 11/5/23.
//

import SwiftUI

@main
struct GrocemateApp: App {
    @StateObject private var hapticEngine: HapticEngine = HapticEngine()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(hapticEngine)
                .environment(\.managedObjectContext, CoreDataController.shared.viewContext)
                .preferredColorScheme(.light)
        }
    }
}
