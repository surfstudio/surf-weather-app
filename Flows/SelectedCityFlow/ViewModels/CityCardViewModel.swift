//
//  CityCardViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 23.05.2022.
//

import Foundation

final class CityCardViewModel {

    // MARK: - Properties

    var onDeleteCity: (() -> Void)?

    // MARK: - Methods

    func deleteCity(with cityName: String) {
        guard let index = UserDefaultsService.shared.savedCities?.firstIndex(where: { $0.cityName == cityName }) else {
            return
        }
        UserDefaultsService.shared.savedCities?.remove(at: index)
        onDeleteCity?()
    }

}
