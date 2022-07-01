//
//  WeatherDiaryTitleViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class WeatherDiaryTitleViewModel: ObservableObject {

    @Published var selectedYear = "2022"
    @Published var showingDatePicker = false
}
