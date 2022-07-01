//
//  MainScreenForecastViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation
import SwiftUI
import Combine

final class MainScreenForecastViewModel: ObservableObject {

    // MARK: - Nested Type

    enum SelectedList: Int {
        case archive = 0
        case forecast = 1
    }

    // MARK: - Properties

    @Published var selectedList: Int = SelectedList.forecast.rawValue
    @Published var items: [ForecastListItemViewModel] = []

    // MARK: - Private Properties

    private var forecastItems: [ForecastListItemViewModel] = []
    private var archiveItems: [ForecastListItemViewModel] = []

    private var cancellables: [AnyCancellable] = []
    private let weatherService: WeatherNetworkService
    private let storageService: WeatherStorageService

    // MARK: - Initialization

    init(weatherService: WeatherNetworkService, storageService: WeatherStorageService) {
        self.weatherService = weatherService
        self.storageService = storageService
    }

    // MARK: - Methods

    func loadData() {
        guard let selectedCity = UserDefaultsService.shared.selectedCity else { return }
        loadWeather(with: selectedCity)
        loadArchiveWeather(with: selectedCity)
    }

}

// MARK: - Private Methods

private extension MainScreenForecastViewModel {

    func loadArchiveWeather(with selectedCity: CityEntity) {
        storageService.getCities { [weak self] result in
            switch result {
            case .success(let entities):
                self?.handleSuccess(with: entities, selectedCity: selectedCity)
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadWeather(with selectedCity: CityEntity) {
        weatherService.getWeather(with: selectedCity.cords) { [weak self] result in
            switch result {
            case .success(let request):
                self?.handleSuccess(with: request, selectedCity: selectedCity)
            case .failure(let error):
                print(error)
            }
        }
    }

    func handleSuccess(with entity: WeatherRequestEntity?, selectedCity: CityEntity) {
        let adapter = MainScreenForecastModelAdapter(weatherDayEntities: entity?.daily ?? [], cityWeather: selectedCity)

        forecastItems = adapter.makeScreenForecastModels().compactMap { model in
                .init(isSelected: archiveItems.contains(where: { $0.model.date == model.date }),
                      model: model,
                      storageService: storageService)
        }

        // Работа чекбокса
        forecastItems.forEach { handleSelectItems(for: $0) }

        sincLists()
    }

    func handleSuccess(with entities: [CityWeatherEntity]?, selectedCity: CityEntity) {
        guard let city = entities?.first(where: { $0.cityName == selectedCity.cityName }) else {
            archiveItems.removeAll()
            return
        }
        let adapter = MainScreenForecastModelAdapter(weatherStorageEntities: city.weatherArray, city: selectedCity)
        let models = adapter.makeScreenForecastModelsByStorage().sorted {
            DateFormat.compareDates($0.date, $1.date, format: .dayLongMonth)
        }
        archiveItems = models.compactMap { .init(isSelected: true, model: $0, storageService: storageService) }

        // Работа чекбокса
        archiveItems.forEach { handleSelectItems(for: $0) }

        sincLists()
    }

    func sincLists() {
        $selectedList.sink { value in
            self.items = value == SelectedList.forecast.rawValue ? self.forecastItems : self.archiveItems
        }.store(in: &self.cancellables)
    }

    func handleSelectItems(for item: ForecastListItemViewModel) {
        item.onSelect = { [weak self] isSelected in
            if isSelected {
                self?.archiveItems.append(item)
            } else {
                guard let index = self?.archiveItems.firstIndex(where: { $0.model.date == item.model.date }) else { return }
                self?.archiveItems.remove(at: index)
            }
            self?.sincLists()
        }
    }

}
