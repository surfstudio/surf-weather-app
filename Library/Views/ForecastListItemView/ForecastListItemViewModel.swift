//
//  MainScreenForecastListItemViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation

final class ForecastListItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var isSelected: Bool
    @Published var model: ForecastListItemView.Model
    let isNeedSeparator: Bool
    let isNeedDayAllocate: Bool
    let storageService: WeatherStorageService

    var onSelect: ((Bool) -> Void)?

    // MARK: - Initialization

    init(
        isSelected: Bool,
        model: ForecastListItemView.Model,
        isNeedSeparator: Bool = true,
        isNeedDayAllocate: Bool = false,
        storageService: WeatherStorageService
    ) {
        self.isSelected = isSelected
        self.isNeedSeparator = isNeedSeparator
        self.isNeedDayAllocate = isNeedDayAllocate
        self.model = model
        self.storageService = storageService
    }

    // MARK: - Actions

    func selectItemAction() {
        isSelected ? deleteWeather() : saveCityWeather()
    }

    func saveCityWeather() {
        storageService.getCities { [weak self] result in
            switch result {
            case .success(let cities):
                self?.handleLoadCities(with: cities)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func saveWeather(by city: CityWeatherEntity, savedWeather: WeeklyWeatherEntityDB) {
        storageService.saveWeather(by: city, weather: savedWeather) { [weak self] result in
            switch result {
            case .success:
                self?.isSelected = true
                self?.onSelect?(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func deleteWeather() {
        storageService.deleteWeather(with: model.cityName, date: model.date) { [weak self] result in
            switch result {
            case .success:
                self?.isSelected = false
                self?.onSelect?(false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func saveCity(with city: CityWeatherEntity) {
        storageService.saveCity(city: city) { [weak self] result in
            switch result {
            case .success:
                self?.isSelected = true
                self?.onSelect?(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func handleLoadCities(with cities: [CityWeatherEntity]?) {
        let savedWeather = MainScreenForecastModelAdapter.makeStorageWeatherEntity(with: model)

        if let city = cities?.first(where: { $0.cityName == model.cityName }) {
            saveWeather(by: city, savedWeather: savedWeather)
        } else {
            let newCity = CityWeatherEntity(
                cityName: model.cityName,
                lat: model.lat,
                lon: model.lon,
                current: nil,
                weekly: [savedWeather],
                hourly: []
            )
            saveCity(with: newCity)
        }
    }

}
