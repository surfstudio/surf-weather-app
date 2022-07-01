//
//  WeatherDiaryForecastListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import Foundation
import SwiftUI

final class WeatherDiaryForecastListViewModel: ObservableObject {

    @Published var items: [ForecastListItemViewModel] = []
    let storageService: WeatherStorageService

    init(storageService: WeatherStorageService) {
        self.storageService = storageService
    }

    func applyYear(_ year: String) {
        UserDefaultsService.shared.dyaryYear = year
        loadData()
    }

    func applyMonth(_ month: String) {
        UserDefaultsService.shared.dyaryMonth = month
        loadData()
    }

    func loadData() {
        storageService.getWeeklyWeather { [weak self] in
            guard case .success(let entities) = $0 else { return }
            self?.makeModels(with: entities ?? [])
        }
    }

    func makeModels(with entities: [WeeklyWeatherEntityDB]) {
        let models = entities.compactMap { entity -> ForecastListItemViewModel? in
            guard
                entity.city?.cityName == UserDefaultsService.shared.selectedCity?.cityName,
                let date = DateFormat.calendarFormatter(format: .dayLongMonth).date(from: entity.date ?? ""),
//                DateFormat.calendarFormatter(format: .year).string(from: date) == UserDefaultsService.shared.dyaryYear,
                DateFormat.calendarFormatter(format: .month).string(from: date) == UserDefaultsService.shared.dyaryMonth
            else { return nil }
            guard
                let city = entity.city,
                let cityName = city.cityName,
                let weekday = entity.weekday,
                let date = entity.date,
                let temperature = entity.temperature,
                let wind = entity.wind,
                let description = entity.specification,
                let imageName = entity.weatherImage
            else { return nil }

            return ForecastListItemViewModel(isSelected: true,
                  model: .init(cityName: cityName,
                               lat: city.lat,
                               lon: city.lon,
                               weekday: weekday,
                               date: date,
                               temperature: temperature,
                               weatherImage: imageName,
                               description: description,
                               wind: wind),
                  isNeedSeparator: true,
                  isNeedDayAllocate: false,
                  storageService: ServicesAssemblyFactory().weatherStorageService
            )
        }

        withAnimation { items = models }
    }

    func sortItems() {
        
    }

}
