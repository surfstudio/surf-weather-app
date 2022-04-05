//
//  WeatherEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 05.04.2022.
//

import Foundation

struct WeatherEntity: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
