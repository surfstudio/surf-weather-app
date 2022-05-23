//
//  CityWeather.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation

struct CityWeather: Codable {
    let cityName: String
    let cords: CordsEntity
    let cityWeather: WeatherRequestEntity
}
