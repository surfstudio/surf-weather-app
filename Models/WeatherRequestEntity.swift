//
//  WeatherDailyRequestEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct WeatherRequestEntity: Codable {
    let current: CurrentWeatherEntity?
    let hourly: [HourlyWeatherEntity]
    let daily: [DailyWeatherEntity]
}
