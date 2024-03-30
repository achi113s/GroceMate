//
//  SettingsViewModel.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/5/24.
//

import SwiftUI

@MainActor protocol SettingsViewModelling: ObservableObject {
    var settingsPath: NavigationPath { get set }
}

@MainActor final class SettingsViewModel: SettingsViewModelling {
    @Published var settingsPath: NavigationPath = NavigationPath()
}
