//
//  ObjectExtension.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Foundation

extension CityWeatherEntity {

    convenience init(cityName: String, lat: Double, lon: Double, weather: Set<StorageWeatherEntity>) {
        self.init(context: StorageContextManager.shared.context)
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
        self.weather = []
        StorageContextManager.shared.context.perform {
            self.addToWeather(weather as NSSet)
        }
    }

    var weatherArray: [StorageWeatherEntity] {
        guard let set = weather as? Set<StorageWeatherEntity> else { return [] }
        return set.reversed()
    }

}

extension StorageWeatherEntity {

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
