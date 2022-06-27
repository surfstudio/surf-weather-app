//
//  CurrentWeatherEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 06.04.2022.
//

import Foundation

struct CurrentWeatherEntity: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let wind_speed: Double
    let weather: [WeatherEntity]
}
