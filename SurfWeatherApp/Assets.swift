//
//  Assets.swift
//  SurfWeatherApp
//
//  Created by porohov on 02.06.2022.
//

import Foundation

enum Assets {

    enum Weather {
        case cloudi, sunCloudi, sun, rain, storm, cold

        var medium: String {
            switch self {
            case .cloudi:
                return "cloudi"
            case .sunCloudi:
                return "sun_cloud"
            case .sun:
                return "sun"
            case .rain:
                return "rain"
            case .storm:
                return "storm"
            case .cold:
                return "cold"
            }
        }

        var name: String {
            switch self {
            case .cloudi:
                return "Облачно"
            case .sunCloudi:
                return "Облачно с прояснениями"
            case .sun:
                return "Солнечно"
            case .rain:
                return "Дождь"
            case .storm:
                return "Дождь с грозой"
            case .cold:
                return "Снег"
            }
        }

    }
}
