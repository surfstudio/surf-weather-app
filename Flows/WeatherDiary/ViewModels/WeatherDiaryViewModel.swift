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
        weatherDiaryForecastListViewModel = .init()
        weatherDiaryMonthListViewModel = .init()
        weatherDiaryTitleViewModel = .init()
        datePickerViewModel = .init()
    }

}
