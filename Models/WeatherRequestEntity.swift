//
//  CityEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct WeatherRequestEntity: Codable {
    let coord: CordsEntity
    let weather: [WeatherEntity]
    let main: TemperatureEntity
}
