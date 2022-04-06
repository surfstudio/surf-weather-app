//
//  MainScreenForecastViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation
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
    @Published var forecastItems: [MainScreenForecastListItemViewModel] = []

    @Published var archiveItems: [MainScreenForecastListItemViewModel] = []

    private var cancellables: [AnyCancellable] = []
    private let weatherService: IWeatherNetworkService
    private var mainScreenForecastModelAdapter: MainScreenForecastModelAdapter? {
        willSet { handleAdapter(with: newValue?.makeScreenForecastModel() ?? []) }
    }

    // MARK: - Initialization

    init() {
        weatherService = ServicesAssembly().weatherNetworkService
        loadWeather(with: .init(lat: 54, lon: 55))
        $selectedList.sink { value in
            self.items = value == SelectedList.forecast.rawValue ? self.forecastItems : self.archiveItems
        }.store(in: &self.cancellables)
    }

}

// MARK: - Private Methods

private extension MainScreenForecastViewModel {

    func loadWeather(with cord: CordsEntity) {
        weatherService.getWeather(with: cord) { [weak self] result in
            switch result {
            case .success(let request):
                self?.mainScreenForecastModelAdapter = .init(weatherDayEntities: request?.daily ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }

    func handleAdapter(with models: [MainScreenForecastListItemView.Model]) {
        forecastItems = models.compactMap { model in
                .init(isSelected: false, model: model)
        }
        archiveItems = models.compactMap { model in
                .init(isSelected: false, model: model)
        }
    }

}
