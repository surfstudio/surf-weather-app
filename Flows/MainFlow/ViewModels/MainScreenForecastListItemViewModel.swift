//
//  MainScreenForecastListItemViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation

final class MainScreenForecastListItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var isSelected: Bool

    // MARK: - Initialization

    init(isSelected: Bool) {
        self.isSelected = isSelected
    }

}
