//
//  SelectCityViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 11.05.2022.
//

import Foundation
import SwiftUI

final class SelectCityViewModel: ObservableObject {

    // MARK: - Properties

    @Published var weathers: [CityCardView.Model] = [ ]
    @Published var showingPopup: Bool = false
    var searchListViewModel: LocationListViewModel
    var cityCardViewModel: CityCardViewModel

    // MARK: - Private Properties

    private var weatherService: WeatherNetworkService
    private var locationService: LocationNetworkService
    private var savedCities = UserDefaultsService.shared.savedCities

    // MARK: - Initialization

    init(weatherService: WeatherNetworkService, locationService: LocationNetworkService) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.searchListViewModel = .init(locationService: locationService, weatherService: weatherService)
        self.cityCardViewModel = .init()

        searchListViewModel.onAddNewCity = { [weak self] in
            self?.loadData()
            self?.showingPopup.toggle()
        }
        cityCardViewModel.onDeleteCity = { [weak self] in
            self?.loadData()
        }
    }

    // MARK: - Methods

    func loadData() {
        guard let entities = UserDefaultsService.shared.savedCities else { return }
        var cities: [CityCardView.Model] = []

        for (index, entity) in entities.enumerated() {
            guard let currentWeather = entity.cityWeather.current else { return }
            let city = makeCityCardModel(with: currentWeather, city: entity.cityName, id: index)
            cities.append(city)
        }

        withAnimation { weathers = cities.sorted(by: { $0.isSelected && !$1.isSelected }) }
    }

    func selectCity(with model: CityCardView.Model) {
        for (index, _) in weathers.enumerated() {
            weathers[index].isSelected = false
        }
        guard let index = weathers.firstIndex(where: { $0.id == model.id }) else {
            return
        }
        let city = savedCities?.first(where: { $0.cityName == model.city })
        UserDefaultsService.shared.selectedCity = city
        weathers[index].isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                let selectedModel = self.weathers.remove(at: index)
                self.weathers.insert(selectedModel, at: 0)
            }
        }
    }

}

// MARK: - Private Methods

private extension SelectCityViewModel {

    func makeCityCardModel(with entity: CurrentWeatherEntity, city: String, id: Int) -> CityCardView.Model {
        let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))

        let dateFormatted = DateFormat.calendarFormatter(format: .dayLongMonth).string(from: date)
        let temp = TemperatureFormatter.format(with: entity.temp, unit: .celsius).replacingOccurrences(of: "°C", with: "")
        let imageName = Assets(rawValue: entity.weather.first?.icon ?? "01d")?.imageName ?? "sun"

        let isSelected = UserDefaultsService.shared.selectedCity?.cityName == city
        return CityCardView.Model(id: id, isSelected: isSelected, temperature: temp, time: dateFormatted, city: city, imageName: imageName)
    }

}
