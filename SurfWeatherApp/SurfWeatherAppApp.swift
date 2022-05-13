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
    let serviceAssembly = ServicesAssemblyFactory()

    var body: some Scene {
        WindowGroup {
//            SelectCityView(viewModel: .init(weatherService: serviceAssembly.weatherNetworkService))
//                .preferredColorScheme(userSettings.isLightMode ? .light : .dark)
            MainScreenView()
                .preferredColorScheme(userSettings.isLightMode ? .light : .dark)
        }
    }

}
