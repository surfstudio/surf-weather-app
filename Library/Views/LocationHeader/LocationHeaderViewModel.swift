//
//  LocationHeaderViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation

final class LocationHeaderViewModel: ObservableObject {

    // MARK: - Nested Types

    enum State {
        case empty
        case loading
        case content(String)
    }

    let selectCityViewModel: SelectCityViewModel

    init(weatherNetworkService: WeatherNetworkService,
         locationNetworkService: LocationNetworkService,
         weatherStorageService: WeatherStorageService) {

        self.selectCityViewModel = .init(weatherService: weatherNetworkService,
                                         locationService: locationNetworkService,
                                         weatherStorageServices: weatherStorageService)
    }

    // MARK: - States

    @Published var state: State = .content(UserDefaultsService.shared.selectedCity?.cityName ?? "")

    // MARK: - Methods

    func update(with cityName: String) {
        print(cityName)
        state = .content(cityName)
        selectCityViewModel.selectCity(with: cityName, isUpdating: true)
    }

}

// MARK: - Actions

extension LocationHeaderViewModel {

    func buttonAction() {
        print("Location button tapped")
    }

}
