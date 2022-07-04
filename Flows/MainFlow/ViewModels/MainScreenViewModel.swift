//
//  MainScreenViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 13.05.2022.
//

import Foundation
import SwiftUI

final class MainScreenViewModel: ObservableObject {

    // MARK: - Properties

    let locationViewModel: LocationHeaderViewModel
    let forecastViewModel: MainScreenForecastViewModel
    @ObservedObject var carouselViewModel: CarouselViewModel

    @Published var isLoading = true

    // MARK: - Initialization

    init(serviceAssembly:  ServicesAssembly) {
        self.locationViewModel = LocationHeaderViewModel(weatherNetworkService: serviceAssembly.weatherNetworkService,
                                                         locationNetworkService: serviceAssembly.locationNetworkService,
                                                         weatherStorageService: serviceAssembly.weatherStorageService)
        self.forecastViewModel = MainScreenForecastViewModel(weatherService: serviceAssembly.weatherNetworkService,
                                                             storageService: serviceAssembly.weatherStorageService)
        self.carouselViewModel = .init(weatherStorageService: serviceAssembly.weatherStorageService,
                                       weatherNetworkService: serviceAssembly.weatherNetworkService)

        carouselViewModel.onChangeSelectedCity = { [weak self] in
            self?.forecastViewModel.loadData()
            self?.locationViewModel.update(with: $0)
            self?.locationViewModel.state = .content($0)
        }

        carouselViewModel.onStartLoading = { [weak self] in self?.isLoading = true }
        carouselViewModel.onStopLoading = { [weak self] in self?.isLoading = false }

        locationViewModel.onChangedCitiesCount = { [weak self] in
            self?.carouselViewModel.update()
        }

        locationViewModel.onSelectCity = { [weak self] cityName in
            self?.carouselViewModel.selectCity(with: cityName)
        }
    }

}
