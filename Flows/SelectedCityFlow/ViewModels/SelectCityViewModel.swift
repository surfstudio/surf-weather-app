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
    var searchText: String = "" { willSet { searchCity(with: newValue) } }

    // MARK: - Private Properties

    private var weatherService: WeatherNetworkService
    private var locationService: LocationNetworkService
    private var loadedWeathers: [CityCardView.Model] = [ ]
    private var searchWeathers: [CityCardView.Model] = [ ]
    private var selectedCity = UserDefaultsService.shared.selectedCity

    // MARK: - Initialization

    init(weatherService: WeatherNetworkService, locationService: LocationNetworkService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    // MARK: - Methods

    func loadData() {
        loadWeather(with: .init(lat: 51, lon: 39), city: "Воронеж", id: 1) { [weak self] in
            self?.loadWeather(with: .init(lat: 62, lon: 54), city: "Москва", id: 2) { [weak self] in
                self?.loadWeather(with: .init(lat: 34, lon: 48), city: "Ижевск", id: 3) { [weak self] in
                    self?.loadWeather(with: .init(lat: 25, lon: 25), city: "Самара", id: 4) { }
                }
            }
        }
    }

}

// MARK: - Private Methods

private extension SelectCityViewModel {

    func searchCity(with text: String) {
        loadedWeathers.forEach {
            if $0.city.contains(text) && !searchWeathers.contains($0) {
                searchWeathers.append($0)
            }
        }
        if text.isEmpty { searchWeathers.removeAll() }
        withAnimation { weathers = text.isEmpty ? loadedWeathers : searchWeathers }
    }

    func loadCities(with cityName: String) {
        locationService.getLocation(with: cityName) { result in
            switch result {
            case .success(let responce):
                guard let responce = responce else {  return }
                let addressComponents = GeocoderEntity(response: responce).getAddressesComponents()
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadWeather(with cord: CordsEntity, city: String, id: Int, completion: @escaping () -> Void) {
        weatherService.getWeather(with: cord) { [weak self] result in
            switch result {
            case .success(let request):
                self?.handleSuccess(with: request, city: city, id: id)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }

    func handleSuccess(with entity: WeatherRequestEntity?, city: String, id: Int) {
        guard let entity = entity?.current else {
            return
        }
        let city = makeCityCardModel(with: entity, city: city, id: id)
        loadedWeathers.append(city)
        let sorted = loadedWeathers.sorted(by: { $0.isSelected && !$1.isSelected })

        loadedWeathers = sorted
        withAnimation { weathers = sorted }
    }

    func makeCityCardModel(with entity: CurrentWeatherEntity, city: String, id: Int) -> CityCardView.Model {
        let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))

        let dateFormatted = DateFormat.calendarFormatter(format: .dayLongMonth).string(from: date)
        let temp = TemperatureFormatter.format(with: entity.temp, unit: .celsius).replacingOccurrences(of: "°C", with: "")
        let imageName = WeatherImageName(rawValue: entity.weather.first?.icon ?? "01d")?.transformImageName() ?? "sun"

        let isSelected = selectedCity == city
        return CityCardView.Model(id: id, isSelected: isSelected, temperature: temp, time: dateFormatted, city: city, imageName: imageName)
    }

}
