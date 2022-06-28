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
    var onChanged: EmptyClosure?
    var onSelectCity: Closure<String>?

    // MARK: - Private Properties

    private var weatherService: WeatherNetworkService
    private var locationService: LocationNetworkService
    private var weatherStorageServices: WeatherStorageService

    // MARK: - Initialization

    init(weatherService: WeatherNetworkService, locationService: LocationNetworkService, weatherStorageServices: WeatherStorageService) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.weatherStorageServices = weatherStorageServices
        self.searchListViewModel = .init(locationService: locationService,
                                         weatherService: weatherService,
                                         weatherStorageServices: weatherStorageServices)
        self.cityCardViewModel = .init(weatherStorageService: weatherStorageServices)

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
        weatherStorageServices.getCities { [weak self] result in
            switch result {
            case .success(let entities):
                self?.handleSuccess(with: entities ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func selectCity(with model: CityCardView.Model) {
        weathers.enumerated().forEach { weathers[$0.offset].isSelected = false }
        guard let index = weathers.firstIndex(where: { $0.id == model.id }) else {
            return
        }
        weatherStorageServices.getCities { [weak self] in
            guard case .success(let entities) = $0, let entity = entities?.first(where: { $0.cityName == model.city }) else {
                return
            }
            UserDefaultsService.shared.selectedCity = .init(cityName: model.city, area: "", cords: .init(lat: entity.lat, lon: entity.lon))
            self?.weathers[index].isSelected = true
            self?.selectCityWithAnimate(by: index)
            self?.onSelectCity?(model.city)
        }
    }

}

// MARK: - Private Methods

private extension SelectCityViewModel {

    func handleSuccess(with entities: [CityWeatherEntity]) {
        var cities: [CityCardView.Model] = []

        entities.enumerated().forEach {
            guard let currentWeather = $0.element.currentWeather, let cityName = $0.element.cityName else { return }
            let city = makeCityCardModel(with: currentWeather, city: cityName, id: $0.offset)
            cities.append(city)
        }

        onChanged?()
        withAnimation { weathers = cities.sorted(by: { $0.isSelected && !$1.isSelected }) }
    }

    func makeCityCardModel(with entity: CurrentWeatherEntityDB, city: String, id: Int) -> CityCardView.Model {
        let date = entity.date ?? ""
        let temp = entity.temperature ?? ""
        let imageName = Assets(rawValue: entity.weatherImage ?? "01d")?.imageName ?? "sun"

        let isSelected = UserDefaultsService.shared.selectedCity?.cityName == city
        return CityCardView.Model(id: id, isSelected: isSelected, temperature: temp, time: date, city: city, imageName: imageName)
    }


    func selectCityWithAnimate(by index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                let selectedModel = self.weathers.remove(at: index)
                self.weathers.insert(selectedModel, at: 0)
            }
        }
    }

}
