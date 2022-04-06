//
//  TempEntity.swift
//  SurfWeatherApp
//
//  Created by porohov on 06.04.2022.
//

import Foundation

struct TempEntity: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
