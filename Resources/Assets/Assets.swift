//
//  Assets.swift
//  SurfWeatherApp
//
//  Created by porohov on 12.05.2022.
//

import Foundation

enum Assets: String {

    case sun = "01d"
    case sunMidle = "02d"
    case cloudy = "03d" , cloudy2 = "04d"
    case rain = "09d", rain2 = "10d"
    case storm = "11d"
    case cold = "13d"


    var imageName: String {
        switch self {
        case .sun:
            return "sun"
        case .sunMidle:
            return "sunMiddle"
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

    var description: String {
        switch self {
        case .cloudy, .cloudy2:
            return "Облачно"
        case .sunMidle:
            return "Облачно с прояснениями"
        case .sun:
            return "Солнечно"
        case .rain, .rain2:
            return "Дождь"
        case .storm:
            return "Дождь с грозой"
        case .cold:
            return "Снег"
        }
    }

}
