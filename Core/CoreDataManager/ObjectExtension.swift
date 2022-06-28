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
        hourly: Set<HourlyWeatherEntityDB>
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

    convenience init(entity: DailyWeatherEntity) {
        self.init(context: StorageContextManager.shared.context)
        let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))
        self.wind = String(entity.wind_speed)
        self.specification = entity.weather.first?.description
        self.weatherImage = entity.weather.first?.icon ?? "01d"
        self.date = DateFormat.calendarFormatter(format: .dayMonthYear).string(from: date)
        self.temperature = TemperatureFormatter.format(with: trunc(entity.temp.day), unit: .celsius)
            .replacingOccurrences(of: "°C", with: "")
            .replacingOccurrences(of: " ", with: "")
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

    convenience init(entity: HourlyWeatherEntity) {
        self.init(context: StorageContextManager.shared.context)
        let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))
        self.wind = String(entity.wind_speed)
        self.specification = entity.weather.first?.description
        self.weatherImage = entity.weather.first?.icon ?? "01d"
        self.date = DateFormat.calendarFormatter(format: .time).string(from: date)
        self.temperature = TemperatureFormatter.format(with: trunc(entity.temp), unit: .celsius)
            .replacingOccurrences(of: "°C", with: "")
            .replacingOccurrences(of: " ", with: "")
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

    convenience init(entity: CurrentWeatherEntity) {
        self.init(context: StorageContextManager.shared.context)
        let date = Date(timeIntervalSince1970: TimeInterval(entity.dt))
        self.weekday = date.weekday
        self.wind = String(entity.wind_speed)
        self.specification = entity.weather.first?.description
        self.weatherImage = entity.weather.first?.icon ?? "01d"
        self.date = DateFormat.calendarFormatter(format: .dayMonthYear).string(from: date)
        self.temperature = TemperatureFormatter.format(with: trunc(entity.temp), unit: .celsius)
            .replacingOccurrences(of: "°C", with: "")
            .replacingOccurrences(of: " ", with: "")
        
    }

}
