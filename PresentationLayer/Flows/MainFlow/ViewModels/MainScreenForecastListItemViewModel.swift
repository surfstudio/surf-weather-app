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
    @Published var weather: WeatherDayEntity?
    let isNeedSeparator: Bool
    let isNeedDayAllocate: Bool

    // MARK: - Initialization

    init(isSelected: Bool, isNeedSeparator: Bool = true, isNeedDayAllocate: Bool = false) {
        self.isSelected = isSelected
        self.isNeedSeparator = isNeedSeparator
        self.isNeedDayAllocate = isNeedDayAllocate
    }

    // MARK: - Actions

    func selectItemAction() {
        print("Selected")
        isSelected.toggle()
    }

}
