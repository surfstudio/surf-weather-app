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
            self?.forecastViewModel.update(with: $0)
            self?.locationViewModel.update(with: $0.cityName)
        }

        carouselViewModel.onStartLoading = { [weak self] in self?.isLoading = true }
        carouselViewModel.onStopLoading = { [weak self] in self?.isLoading = false }

        locationViewModel.selectCityViewModel.onChangedItemCount = { [weak self] in
            self?.carouselViewModel.update(with: $0)
        }

        locationViewModel.selectCityViewModel.onSelectCity = { [weak self] cityName in
            self?.carouselViewModel.selectCity(with: cityName)
        }
    }

}
