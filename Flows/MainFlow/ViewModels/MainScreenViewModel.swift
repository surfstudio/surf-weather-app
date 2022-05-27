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
    let carouselViewModel: MainCorouselViewModel

    // MARK: - Initialization

    init(serviceAssembly:  ServicesAssembly) {
        self.locationViewModel = LocationHeaderViewModel()
        self.forecastViewModel = MainScreenForecastViewModel(weatherService: serviceAssembly.weatherNetworkService,
                                                             storageService: serviceAssembly.weatherStorageService)
        self.carouselViewModel = .init()
    }

}
