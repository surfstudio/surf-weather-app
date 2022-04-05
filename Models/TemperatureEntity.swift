//
//  TemperatureEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct TemperatureEntity: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}
