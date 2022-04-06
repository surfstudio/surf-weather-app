//
//  MainScreenForecastModelAdapter.swift
//  SurfWeatherApp
//
//  Created by porohov on 06.04.2022.
//

import Foundation

class MainScreenForecastModelAdapter {

    // MARK: - Private Properties

    private let weatherDayEntities: [DailyWeatherEntity]

    // MARK: - Initialization

    init(weatherDayEntities: [DailyWeatherEntity]) {
        self.weatherDayEntities = weatherDayEntities
    }

    // MARK: - Methods

    func makeScreenForecastModels() -> [MainScreenForecastListItemView.Model] {

        weatherDayEntities.prefix(5).compactMap { entity -> MainScreenForecastListItemView.Model in
            let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))

            let dateFormatted = DateFormat.calendarFormatter(format: .dayLongMonth).string(from: date)
            let temp = TemperatureFormatter.format(with: entity.temp.day, unit: .celsius)
            let imageName = entity.weather.first?.icon ?? "01d"
            let description = entity.weather.first?.description ?? ""
            let wind = "\(entity.wind_speed) м/с"

            return .init(weekday: date.weekday,
                         date: dateFormatted,
                         temperature: temp,
                         weatherImage: imageName,
                         description: description,
                         wind: wind)
        }
    }

}
