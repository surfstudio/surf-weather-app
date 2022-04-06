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
    @Published var items: [MainScreenForecastListItemViewModel] = []

    private var forecastItems: [MainScreenForecastListItemViewModel] = []
    private var archiveItems: [MainScreenForecastListItemViewModel] = []

    private var cancellables: [AnyCancellable] = []
    private let weatherService: IWeatherNetworkService
    private var mainScreenForecastModelAdapter: MainScreenForecastModelAdapter?

    // MARK: - Initialization

    init() {
        weatherService = ServicesAssembly().weatherNetworkService
    }

    // MARK: - Methods

    func loadData() {
        loadWeather(with: .init(lat: 51, lon: 39))
    }

}

// MARK: - Private Methods

private extension MainScreenForecastViewModel {

    func loadWeather(with cord: CordsEntity) {
        weatherService.getWeather(with: cord) { [weak self] result in
            switch result {
            case .success(let request):
                self?.handleSuccess(with: request)
            case .failure(let error):
                print(error)
            }
        }
    }

    func handleSuccess(with entity: WeatherRequestEntity?) {
        mainScreenForecastModelAdapter = .init(weatherDayEntities: entity?.daily ?? [])
        let models = mainScreenForecastModelAdapter?.makeScreenForecastModels() ?? []
        forecastItems = models.compactMap { .init(isSelected: false, model: $0) }

        $selectedList.sink { value in
            self.items = value == SelectedList.forecast.rawValue ? self.forecastItems : self.archiveItems
        }.store(in: &self.cancellables)
    }

}
