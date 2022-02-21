//
//  UserDefaultsService.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation
import SwiftUI

final class UserDefaultsService {

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Static Properties

    static let shared = UserDefaultsService()

    // MARK: - Keys

    private enum Keys: String {
        case isLightMode
    }

    // MARK: - Properties

    var isLightMode: Bool {
        get {
            if let isDarkMode = UserDefaults.standard.object(forKey: Keys.isLightMode.rawValue) as? Bool {
                return isDarkMode
            } else {
                let isLightMode = colorScheme == .light
                self.isLightMode = isLightMode
                return isLightMode
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isLightMode.rawValue)
        }
    }

    // MARK: - Initialization

    private init() {}

}
