//
//  ObjectExtension.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Foundation

extension CityWeatherEntity {

    convenience init(
        cityName: String,
        lat: Double,
        lon: Double,
        current: CurrentWeatherEntityDB?,
        weekly: Set<WeeklyWeatherEntityDB>,
        hourly: Set<WeeklyWeatherEntityDB>
    ) {
        self.init(context: StorageContextManager.shared.context)
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
        self.currentWeather = current
        self.weeklyWeather = []
        self.hourlyWeather = []
        StorageContextManager.shared.context.perform {
            self.addToWeeklyWeather(weekly as NSSet)
            self.addToHourlyWeather(hourly as NSSet)
        }
    }

    var weatherArray: [WeeklyWeatherEntityDB] {
        guard let set = weeklyWeather as? Set<WeeklyWeatherEntityDB> else { return [] }
        return set.reversed()
    }

}

extension WeeklyWeatherEntityDB {

    convenience init(
        weekday: String,
        wind: String,
        specification: String,
        weatherImage: String,
        temperature: String,
        date: String
    ) {
        self.init(context: StorageContextManager.shared.context)
        self.weekday = weekday
        self.wind = wind
        self.specification = specification
        self.weatherImage = weatherImage
        self.temperature = temperature
        self.date = date
    }

}

extension HourlyWeatherEntityDB {

    convenience init(
        wind: String,
        specification: String,
        weatherImage: String,
        temperature: String,
        date: String
    ) {
        self.init(context: StorageContextManager.shared.context)
        self.wind = wind
        self.specification = specification
        self.weatherImage = weatherImage
        self.temperature = temperature
        self.date = date
    }

}

extension CurrentWeatherEntityDB {

    convenience init(
        weekday: String,
        wind: String,
        specification: String,
        weatherImage: String,
        temperature: String,
        date: String
    ) {
        self.init(context: StorageContextManager.shared.context)
        self.weekday = weekday
        self.wind = wind
        self.specification = specification
        self.weatherImage = weatherImage
        self.temperature = temperature
        self.date = date
    }

}
