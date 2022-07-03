//
//  WeatherDiaryListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import Foundation

final class WeatherDiaryViewModel: ObservableObject {

    let weatherDiaryForecastListViewModel: WeatherDiaryForecastListViewModel
    let weatherDiaryMonthListViewModel: WeatherDiaryMonthListViewModel
    let weatherDiaryTitleViewModel: WeatherDiaryTitleViewModel
    let datePickerViewModel: DatePickerViewModel

    init() {
        Self.initialStorage()
        weatherDiaryForecastListViewModel = .init(storageService: ServicesAssemblyFactory().weatherStorageService)
        weatherDiaryMonthListViewModel = .init()
        weatherDiaryTitleViewModel = .init()
        datePickerViewModel = .init()

        datePickerViewModel.onChangeYear = { [weak self] year in
            self?.weatherDiaryTitleViewModel.applyYear(year)
            self?.weatherDiaryForecastListViewModel.applyYear(year)
        }
        weatherDiaryMonthListViewModel.onSelectedMonth = { [weak self] month in
            self?.weatherDiaryForecastListViewModel.applyMonth(month)
        }
    }

}

private extension WeatherDiaryViewModel {

    static func initialStorage() {
        if UserDefaultsService.shared.dyaryYear == nil {
            UserDefaultsService.shared.dyaryYear = DateFormat.calendarFormatter(format: .year).string(from: Date())
        }
        if UserDefaultsService.shared.dyaryMonth == nil {
            UserDefaultsService.shared.dyaryMonth = DateFormat.calendarFormatter(format: .month).string(from: Date())
        }
    }

}
