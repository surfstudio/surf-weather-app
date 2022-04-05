//
//  WeatherDailyRequestEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct WeatherDailyRequestEntity: Codable {
    let daily: [WeatherDayEntity]
}

struct WeatherDayEntity: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: TempEntity
    let weather: [WeatherEntity]
    let rain: Double?
}

struct TempEntity: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
