//
//  UserDefaultsService.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation
import SwiftUI

final class UserDefaultsService: ObservableObject {

    // MARK: - Environments

    @Environment(\.colorScheme) var colorScheme

    // MARK: - Properties

    @Published var isLightMode: Bool = false {
        didSet {
            UserDefaults.standard.set(isLightMode, forKey: Keys.isLightMode.rawValue)
        }
    }

    // MARK: - Static Properties

    static let shared = UserDefaultsService()

    // MARK: - Keys

    private enum Keys: String {
        case isLightMode
    }

    // MARK: - Initialization

    private init() {
        setColorMode()
    }

    // MARK: - Private Methods

    func setColorMode() {
        if let isLightMode = UserDefaults.standard.object(forKey: Keys.isLightMode.rawValue) as? Bool {
            self.isLightMode = isLightMode
        } else {
            self.isLightMode = colorScheme == .light
        }
    }

}
