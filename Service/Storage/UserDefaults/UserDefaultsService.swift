//
//  UserDefaultsService.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation
import SwiftUI
import CoreData

final class UserDefaultsService: ObservableObject, Storage {

    // MARK: - Environments

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Properties

    @Published var isLightMode: Bool = false {
        didSet { setValue(for: isLightMode, key: Keys.isLightMode.rawValue) }
    }

    @Published var selectedCity: CityEntity? = UserDefaultsService.getValue(key: Keys.selectedCity.rawValue) {
        didSet { setValue(for: selectedCity, key: Keys.selectedCity.rawValue) }
    }

    var currentPage: CGFloat? {
        get { getValue(key: Keys.currentPage.rawValue) }
        set { setValue(for: newValue, key: Keys.currentPage.rawValue) }
    }

    // MARK: - Static Properties

    static let shared = UserDefaultsService()

    // MARK: - Keys

    private enum Keys: String {
        case isLightMode
        case selectedCity
        case currentPage
    }

    // MARK: - Initialization

    private init() {
        setPublished()
    }

    // MARK: - Private Methods

    func setPublished() {
        isLightMode = getValue(key: Keys.isLightMode.rawValue) ?? (colorScheme == .light)
        selectedCity = getValue(key: Keys.selectedCity.rawValue)
    }

}
