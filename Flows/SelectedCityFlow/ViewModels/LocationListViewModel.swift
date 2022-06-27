//
//  LocationListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import Foundation

final class LocationListViewModel: ObservableObject {

    // MARK: - Properties

    @Published var locations: [String] = [ ]
    var searchText: String = "" { willSet { searchCity(with: newValue) } }
    var onAddNewCity: (() -> Void)?

    // MARK: - Private Properties

    private var locationService: LocationNetworkService
    private var weatherService: WeatherNetworkService
    private var weatherStorageServices: WeatherStorageService
    private var cities: [CityEntity] = [ ]

    // MARK: - Initialization

    init(locationService: LocationNetworkService, weatherService: WeatherNetworkService, weatherStorageServices: WeatherStorageService) {
        self.locationService = locationService
        self.weatherService = weatherService
        self.weatherStorageServices = weatherStorageServices
    }

    // MARK: - Methods

    func addNewCity(with index: Int) {
        let city = cities[index]
        loadWeather(with: city.cords, cityName: city.cityName)
    }

}

// MARK: - Private Methods

private extension LocationListViewModel {

    func searchCity(with text: String) {
        loadLocations(with: text)
    }

    func loadLocations(with cityName: String) {
        locationService.getLocation(with: cityName) { [weak self] result in
            switch result {
            case .success(let responce):
                self?.handleSuccess(with: responce)
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadWeather(with cord: CordsEntity, cityName: String) {
        weatherService.getWeather(with: cord) { [weak self] result in
            switch result {
            case .success(let request):
                self?.handleSuccess(with: request, cityName: cityName, cords: cord)
            case .failure(let error):
                print(error)
            }
        }
    }

    func handleSuccess(with responce: GeocoderResponseEntry?) {
        guard let responce = responce else { return }
        let addressComponents = GeocoderEntity(response: responce).getAddressesComponents()
        
        cities = addressComponents.compactMap {
            guard let cityName = $0.locality, let cords = $0.coordsEntity else { return nil }
            return .init(cityName: cityName, area: $0.area ?? "", cords: cords)
        }
        locations = cities.map { [$0.cityName, $0.area].filter { !$0.isEmpty }.joined(separator: ", ") }
    }

    func handleSuccess(with entity: WeatherRequestEntity?, cityName: String, cords: CordsEntity) {
        guard let current = entity?.current else {
            return
        }

        let weekly = entity?.daily.compactMap { WeeklyWeatherEntityDB(entity: $0) } ?? []
        let hourly = entity?.hourly.compactMap { HourlyWeatherEntityDB(entity: $0) } ?? []

        let newCity = CityWeatherEntity(
            cityName: cityName,
            lat: cords.lat,
            lon: cords.lon,
            current: .init(entity: current),
            weekly: Set(weekly),
            hourly: Set(hourly)
        )

        weatherStorageServices.saveCity(city: newCity, completion: { [weak self] result in
            switch result {
            case .success():
                self?.onAddNewCity?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }

}
