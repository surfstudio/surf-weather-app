//
//  MainScreenForecastModelAdapter.swift
//  SurfWeatherApp
//
//  Created by porohov on 06.04.2022.
//

import Foundation

class MainScreenForecastModelAdapter {

    // MARK: - Private Properties

    private var weatherDayEntities: [DailyWeatherEntity] = []
    private var weatherStorageEntities: [WeeklyWeatherEntityDB] = []
    private var cityName: String
    private var cord: CordsEntity

    // MARK: - Initialization

    init(weatherDayEntities: [DailyWeatherEntity], cityWeather: CityWeather) {
        self.weatherDayEntities = weatherDayEntities
        self.cityName = cityWeather.cityName
        self.cord = cityWeather.cords
    }

    init(weatherStorageEntities: [WeeklyWeatherEntityDB], cityWeather: CityWeather) {
        self.weatherStorageEntities = weatherStorageEntities
        self.cityName = cityWeather.cityName
        self.cord = cityWeather.cords
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

            return .init(cityName: cityName,
                         lat: cord.lat,
                         lon: cord.lon,
                         weekday: date.weekday,
                         date: dateFormatted,
                         temperature: temp,
                         weatherImage: imageName,
                         description: description,
                         wind: wind)
        }
    }

    func makeScreenForecastModelsByStorage() -> [MainScreenForecastListItemView.Model] {
        var models: [MainScreenForecastListItemView.Model] = []

        for entity in weatherStorageEntities {

            let model = MainScreenForecastListItemView.Model(
                cityName: cityName,
                lat: cord.lat,
                lon: cord.lon,
                weekday: entity.weekday ?? "",
                date: entity.date ?? "",
                temperature: entity.temperature ?? "",
                weatherImage: entity.weatherImage ?? "",
                description: entity.specification ?? "",
                wind: entity.wind ?? ""
            )
            models.append(model)
        }
        return models
    }

    static func makeStorageWeatherEntity(with model: MainScreenForecastListItemView.Model) -> WeeklyWeatherEntityDB {
        return WeeklyWeatherEntityDB(
            weekday: model.weekday,
            wind: model.wind,
            specification: model.description,
            weatherImage: model.weatherImage,
            temperature: model.temperature,
            date: model.date
        )
    }

    static func makeCityWeatherEntity(with model: MainScreenForecastListItemView.Model) -> CityWeatherEntity {
        return CityWeatherEntity(
            cityName: model.cityName,
            lat: model.lat,
            lon: model.lon,
            current: nil,
            weekly: [],
            hourly: []
        )
    }

}
