//
//  Assets.swift
//  SurfWeatherApp
//
//  Created by porohov on 12.05.2022.
//

import Foundation
import SwiftUI

extension String {

    static func | (_ light: String, _ dark: String) -> String {
        return UserDefaultsService.shared.isLightMode ? light : dark
    }
}

enum Assets: String {

    case sun = "01d", sunNight = "01n"
    case sunMidle = "02d", sunMidleNight = "02n"
    case cloudy = "03d" , cloudy2 = "04d", cloudyNight = "03n", cloudy2Night = "04n"
    case rain = "09d", rain2 = "10d", rainNight = "09n", rain2Night = "10n"
    case storm = "11d", stormNight = "11n"
    case cold = "13d", coldNight = "13n"


    var imageName: String {
        switch self {
        case .sun, .sunNight:
            return "sun"
        case .sunMidle, .sunMidleNight:
            return "sunMiddle"
        case .cloudy, .cloudy2, .cloudyNight, .cloudy2Night:
            return "cloudy"
        case .rain, .rain2, .rainNight, .rain2Night:
            return "rain"
        case .storm, .stormNight:
            return "storm"
        case .cold, .coldNight:
            return "cold"
        }
    }

    var description: String {
        switch self {
        case .sun, .sunNight:
            return "Облачно"
        case .sunMidle, .sunMidleNight:
            return "Облачно с прояснениями"
        case .cloudy, .cloudy2, .cloudyNight, .cloudy2Night:
            return "Солнечно"
        case .rain, .rain2, .rainNight, .rain2Night:
            return "Дождь"
        case .storm, .stormNight:
            return "Дождь с грозой"
        case .cold, .coldNight:
            return "Снег"
        }
    }

}
