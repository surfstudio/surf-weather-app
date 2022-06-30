//
//  CityEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import Foundation

struct CityEntity: Codable {
    let cityName: String
    let area: String
    let cords: CordsEntity
}
