//
//  MainScreenViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 13.05.2022.
//

import Foundation

final class MainScreenViewModel {

    // MARK: - Properties

    let locationViewModel: LocationHeaderViewModel
    let forecastViewModel: MainScreenForecastViewModel

    // MARK: - Initialization

    init(serviceAssembly:  ServicesAssemblyFactory) {
        self.locationViewModel = LocationHeaderViewModel()
        self.forecastViewModel = MainScreenForecastViewModel(weatherService: serviceAssembly.weatherNetworkService)
    }

}
