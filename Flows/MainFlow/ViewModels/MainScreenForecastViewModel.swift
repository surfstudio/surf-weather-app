//
//  MainScreenForecastViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import Foundation
import Combine

final class MainScreenForecastViewModel: ObservableObject {

    // MARK: - Nested Type

    enum SelectedList: Int {
        case archive = 0
        case forecast = 1
    }

    // MARK: - Properties

    @Published var selectedList: Int = SelectedList.forecast.rawValue
    @Published var items: [MainScreenForecastListItemViewModel] = []
    @Published var forecastItems = [
        MainScreenForecastListItemViewModel(isSelected: true, isNeedDayAllocate: true),
        MainScreenForecastListItemViewModel(isSelected: false),
        MainScreenForecastListItemViewModel(isSelected: false),
        MainScreenForecastListItemViewModel(isSelected: false),
        MainScreenForecastListItemViewModel(isSelected: true, isNeedSeparator: false),
    ]

    @Published var archiveItems = [
        MainScreenForecastListItemViewModel(isSelected: true, isNeedDayAllocate: false),
        MainScreenForecastListItemViewModel(isSelected: true),
        MainScreenForecastListItemViewModel(isSelected: true),
        MainScreenForecastListItemViewModel(isSelected: true),
        MainScreenForecastListItemViewModel(isSelected: true, isNeedSeparator: false),
    ]

    private var cancellables: [AnyCancellable] = []

    // MARK: - Initialization

    init() {
        $selectedList.sink { value in
            self.items = value == SelectedList.forecast.rawValue ? self.forecastItems : self.archiveItems
        }.store(in: &self.cancellables)
    }

}
