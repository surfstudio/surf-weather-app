//
//  WeatherDiaryTitleViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class WeatherDiaryTitleViewModel: ObservableObject {

    @Published var selectedYear = UserDefaultsService.shared.dyaryYear ?? ""
    @Published var years = [String]()

    init() {
        guard let currentYear = Int(DateFormat.calendarFormatter(format: .year).string(from: Date())) else { return }
        years = ((currentYear - 10)...currentYear).compactMap { "\($0)" }
    }

    func applyYear(_ year: String) {
        selectedYear = year
    }
}

private extension WeatherDiaryTitleViewModel {

    func initialStorage() {
        
    }
}
