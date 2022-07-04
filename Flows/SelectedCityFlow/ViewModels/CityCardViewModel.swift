//
//  CityCardViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation

final class CityCardViewModel {

    // MARK: - Properties

    var onDeleteCity: (() -> Void)?

    // MARK: - Private Properties

    private let weatherStorageService: WeatherStorageService

    // MARK: - Initialization

    init(weatherStorageService: WeatherStorageService) {
        self.weatherStorageService = weatherStorageService
    }

    // MARK: - Methods

    func deleteCity(with cityName: String) {
        weatherStorageService.getCities { [weak self] result in
            guard case .success(let entity) = result, let city = entity?.first(where: { $0.cityName == cityName }) else { return }

            self?.weatherStorageService.deleteCity(city: city, completion: { _ in
                guard case .success = result else { return }
                self?.onDeleteCity?()
            })
        }
    }

}
