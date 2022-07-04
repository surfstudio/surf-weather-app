//
//  DatePickerViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class DatePickerViewModel: ObservableObject {

    @Published var currentYear = UserDefaultsService.shared.dyaryYear ?? ""
    @Published var years = [String]()

    var onChangeYear: Closure<String>?

    init() {
        guard let currentYear = Int(DateFormat.calendarFormatter(format: .year).string(from: Date())) else { return }
        years = ((currentYear - 10)...currentYear).compactMap { "\($0)" }
    }

    func applyDate() {
        onChangeYear?(String(currentYear))
    }

}
