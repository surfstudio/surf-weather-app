//
//  SurfWeatherAppApp.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.02.2022.
//

import SwiftUI

@main
struct SurfWeatherAppApp: App {

    @ObservedObject var userSettings = UserDefaultsService.shared

    var body: some Scene {
        WindowGroup {
            MainScreenView(viewModel: MainScreenViewModel(serviceAssembly: .init()))
                .preferredColorScheme(userSettings.isLightMode ? .light : .dark)
        }
    }

}
