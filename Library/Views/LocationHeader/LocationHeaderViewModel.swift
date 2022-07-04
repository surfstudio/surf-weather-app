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

    // MARK: - Properties

    var onSelectCity: Closure<String>?
    var onChangedCitiesCount: EmptyClosure?

    // MARK: - Private Properties

    let selectCityViewModel: SelectCityViewModel

    init(weatherNetworkService: WeatherNetworkService,
         locationNetworkService: LocationNetworkService,
         weatherStorageService: WeatherStorageService) {

        self.selectCityViewModel = .init(weatherService: weatherNetworkService,
                                         locationService: locationNetworkService,
                                         weatherStorageServices: weatherStorageService)

        selectCityViewModel.onSelectCity = { [weak self] city in
            self?.onSelectCity?(city)
        }
        selectCityViewModel.onChangedCitiesCount = { [weak self] in
            self?.onChangedCitiesCount?()
        }
    }

    // MARK: - States

    @Published var state: State = .content(UserDefaultsService.shared.selectedCity?.cityName ?? "")

    // MARK: - Methods

    func update(with cityName: String) {
        state = .loading
        selectCityViewModel.selectCity(with: cityName, isUpdating: true)
    }

}

// MARK: - Actions

extension LocationHeaderViewModel {

    func buttonAction() {
        print("Location button tapped")
    }

}
