//
//  UserDefaultsService.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation
import SwiftUI

final class UserDefaultsService: ObservableObject, Storage {

    // MARK: - Environments

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Properties

    @Published var isLightMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isLightMode, forKey: Keys.isLightMode.rawValue)
        }
    }

    var selectedCity: CityWeather? {
        get { getValue(key: Keys.selectedCity.rawValue) }
        set { setValue(for: newValue, key: Keys.selectedCity.rawValue) }
    }

    var savedCities: [CityWeather]? {
        get { getValue(key: Keys.savedCities.rawValue) }
        set { setValue(for: newValue, key: Keys.savedCities.rawValue) }
    }

    // MARK: - Static Properties

    static let shared = UserDefaultsService()

    // MARK: - Keys

    private enum Keys: String {
        case isLightMode
        case selectedCity
        case savedCities
    }

    // MARK: - Initialization

    private init() {
        setColorMode()
    }

    // MARK: - Private Methods

    func setColorMode() {
        isLightMode = getValue(key: Keys.isLightMode.rawValue) ?? (colorScheme == .light)
    }

}
