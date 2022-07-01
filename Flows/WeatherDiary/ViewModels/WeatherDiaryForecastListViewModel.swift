//
//  WeatherDiaryForecastListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import Foundation

final class WeatherDiaryForecastListViewModel: ObservableObject {

    let items: [ForecastListItemViewModel]

    init() {
        items = Array(repeating: Self.makeModel(), count: 20)
    }

    static func makeModel() -> ForecastListItemViewModel {
        .init(isSelected: false,
              model: .init(cityName: "Воронеж",
                           lat: 25,
                           lon: 25,
                           weekday: "Сегодня",
                           date: "11 апреля",
                           temperature: "5℃",
                           weatherImage: "01d",
                           description: "Сильный ветер",
                           wind: "7 м/с"),
              isNeedSeparator: true,
              isNeedDayAllocate: false,
              storageService: ServicesAssemblyFactory().weatherStorageService
        )
    }

}
