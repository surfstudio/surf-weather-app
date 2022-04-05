//
//  MainScreenForecastListItemViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation

final class MainScreenForecastListItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var isSelected: Bool
    @Published var daily: [WeatherDayEntity] = []
    let isNeedSeparator: Bool
    let isNeedDayAllocate: Bool
    let weatherService: IWeatherNetworkService

    // MARK: - Initialization

    init(isSelected: Bool, isNeedSeparator: Bool = true, isNeedDayAllocate: Bool = false) {
        self.isSelected = isSelected
        self.isNeedSeparator = isNeedSeparator
        self.isNeedDayAllocate = isNeedDayAllocate
        self.weatherService = ServicesAssembly().weatherNetworkService
        loadWeather(with: .init(lat: 55, lon: 54))
    }

    // MARK: - Actions

    func selectItemAction() {
        print("Selected")
        isSelected.toggle()
    }

}

// MARK: - Private Methods

private extension MainScreenForecastListItemViewModel {

    func loadWeather(with cord: CordsEntity) {
        weatherService.getWeatherDaily(with: cord) { [weak self] result in
            switch result {
            case .success(let request):
                self?.daily = request?.daily ?? []
            case .failure(let error):
                print(error)
            }
        }
    }

}
