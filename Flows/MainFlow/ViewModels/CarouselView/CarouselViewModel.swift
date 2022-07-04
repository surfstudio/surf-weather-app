//
//  CarouselViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation
import SwiftUI

final class CarouselViewModel: ObservableObject {

    @Published var updateIsNeeded = false
    @Published var cardViewModels: [CardViewModel] = []

    var onChangeSelectedCity: Closure<String>?
    var onChangePage: Closure<CGFloat>?
    var onStartLoading: EmptyClosure?
    var onStopLoading: EmptyClosure?

    private let weatherStorageService: WeatherStorageService
    private let weatherNetworkService: WeatherNetworkService

    private var cities = [CityEntity]()

    init(weatherStorageService: WeatherStorageService, weatherNetworkService: WeatherNetworkService) {
        self.weatherStorageService = weatherStorageService
        self.weatherNetworkService = weatherNetworkService
        loadData()
    }

    func loadData(completion: EmptyClosure? = nil) {
        onStartLoading?()
        weatherStorageService.getCities { [weak self] in
            guard case .success(let entities) = $0 else { return }
            self?.cardViewModels.removeAll()
            self?.cities.removeAll()
            entities?.forEach {
                guard let cityName = $0.cityName else { return }
                let isLast = $0 === entities?.last(where: { $0.cityName != nil })
                self?.loadWeather(for: .init(lat: $0.lat, lon: $0.lon), cityName: cityName, completion: isLast ? completion : nil)
            }
        }
    }

    func update() {
        self.loadData() { [weak self] in
            DispatchQueue.main.async {
                self?.selectCity(with: UserDefaultsService.shared.selectedCity?.cityName ?? "")
            }
        }
    }

    func selectCity(with cityName: String) {
        guard let index = cardViewModels.firstIndex(where: { $0.model.city == cityName }) else { return }
        onChangePage?(CGFloat(index))
    }

    func changePage(with index: Int) {
        UserDefaultsService.shared.selectedCity = cities[index]
        onChangeSelectedCity?(cities[index].cityName)
    }

}

private extension CarouselViewModel {

    func loadWeather(for cords: CordsEntity, cityName: String, completion: EmptyClosure?) {
        weatherNetworkService.getWeather(with: cords) { [weak self] in
            guard case .success(let request) = $0 else { return }
            self?.handleSuccess(with: request, cords: cords, cityName: cityName, completion: completion)
        }
    }

    func handleSuccess(with request: WeatherRequestEntity?, cords: CordsEntity, cityName: String, completion: EmptyClosure?) {
        guard
            let request = request,
            let current = request.current,
            let imageName = current.weather.first?.icon,
            let image = Assets(rawValue: imageName)
        else { return }

        let roundedTemp = String(Int(current.temp))
        let hourlyModels = getHourly(with: request.hourly, currentDate: current.dt)
        let date = Date(timeIntervalSince1970: TimeInterval(current.dt))
        let currentDate = [date.weekday, DateFormat.calendarFormatter(format: .dayLongMonth).string(from: date)].joined(separator: ", ")
        let vm = CardViewModel(model: .init(city: cityName, date: currentDate, temperature: roundedTemp, image: image, hourly: hourlyModels))
        cardViewModels.append(vm)
        cities.append(.init(cityName: cityName, area: "", cords: cords))

        withAnimation { self.updateIsNeeded = true }
        onStopLoading?()
        completion?()
    }

    func getHourly(with entities: [HourlyWeatherEntity], currentDate: Int) -> [HourlyCardView.Model] {
        let models = entities.prefix(12).compactMap { entity -> HourlyCardView.Model? in
            guard
                let imageName = entity.weather.first?.icon,
                let image = Assets(rawValue: imageName)
            else { return nil }

            let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))
            let time = DateFormat.calendarFormatter(format: .time).string(from: date)

            let currentDate = Date(timeIntervalSince1970: TimeInterval(currentDate))
            let currentTime = DateFormat.calendarFormatter(format: .hour).string(from: currentDate)

            let temp = String(Int(entity.temp))

            let comparableTime = DateFormat.calendarFormatter(format: .hour).string(from: date)
            let isSelected = currentTime == comparableTime

            return .init(time: time, temperature: temp, image: image, isSelected: isSelected)
        }

        return models
    }

}
