//
//  Assets.swift
//  SurfWeatherApp
//
//  Created by porohov on 12.05.2022.
//

import Foundation

enum WeatherImageName: String {
    case sun = "01d"
    case sunMidle = "02d"
    case cloudy = "03d" , cloudy2 = "04d"
    case rain = "09d", rain2 = "10d"
    case storm = "11d"
    case cold = "13d"


    func transformImageName() -> String {
        switch self {
        case .sun:
            return "sun"
        case .sunMidle:
            return "sunMidle"
        case .cloudy, .cloudy2:
            return "cloudy"
        case .rain, .rain2:
            return "rain"
        case .storm:
            return "storm"
        case .cold:
            return "cold"
        }
    }
}
