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

    private let weatherStorageService: WeatherStorageService

    init(weatherStorageService: WeatherStorageService) {
        self.weatherStorageService = weatherStorageService
        loadData()
    }

    func loadData() {
        weatherStorageService.getCities { [weak self] in
            guard case .success(let entities) = $0 else { return }
            self?.handleSuccess(with: entities ?? [])
        }
    }

    func selectCity(with cityName: String) {
        let sorted = cardViewModels.sorted(by: { $0.model.city == cityName && $1.model.city != cityName })
        cardViewModels = sorted
        updateIsNeeded = true
    }

}

private extension CarouselViewModel {

    func handleSuccess(with entities: [CityWeatherEntity]) {
        cardViewModels.removeAll()
        entities.forEach {
            guard
                let cityName = $0.cityName,
                let temp = $0.currentWeather?.temperature,
                let imageName = $0.currentWeather?.weatherImage,
                let image = Assets(rawValue: imageName)
            else { return }

            let cardModel = CardView.Model(city: cityName, temperature: temp, image: image, hourly: getHourly(with: $0))
            cardViewModels.append(.init(model: cardModel))
        }

        withAnimation { self.updateIsNeeded = true }
    }

    func getHourly(with entity: CityWeatherEntity) -> [HourlyCardView.Model] {
        let hourly = entity.hourlyWeather as? Set<HourlyWeatherEntityDB>
        let models = hourly?.compactMap { hour -> HourlyCardView.Model? in
            guard
                hour.city?.cityName == entity.cityName,
                let time = hour.date,
                let temp = hour.temperature,
                let imageName = hour.weatherImage,
                let image = Assets(rawValue: imageName)
            else { return nil }
            let isSelected = hour.date == entity.currentWeather?.date
            return .init(time: time, temperature: temp, image: image, isSelected: isSelected)
        }

        return models ?? []
    }
}

let hourly: [HourlyCardView.Model] = [
    .init(time: "12:00", temperature: "20", image: .sun, isSelected: false),
    .init(time: "13:00", temperature: "25", image: .sunMidle, isSelected: true),
    .init(time: "14:00", temperature: "14", image: .rain, isSelected: false),
    .init(time: "15:00", temperature: "8", image: .storm, isSelected: false),
    .init(time: "16:00", temperature: "15", image: .cloudy, isSelected: false),
    .init(time: "17:00", temperature: "8", image: .cloudy, isSelected: false),
    .init(time: "18:00", temperature: "15", image: .sunMidle, isSelected: false),
    .init(time: "19:00", temperature: "8", image: .sunMidle, isSelected: false),
    .init(time: "20:00", temperature: "15", image: .sun, isSelected: false)
]
