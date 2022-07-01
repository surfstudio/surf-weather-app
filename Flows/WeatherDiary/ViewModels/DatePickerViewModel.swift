//
//  DatePickerViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class DatePickerViewModel: ObservableObject {

    @Published var currentYear = 2022
    var onChangeYear: Closure<String>?

    func applyDate() {
        onChangeYear?(String(currentYear))
    }

}
