//
//  WeatherDailyRequestEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct WeatherRequestEntity: Codable {
    let current: CurrentWeatherEntity?
    let daily: [DailyWeatherEntity]
}
