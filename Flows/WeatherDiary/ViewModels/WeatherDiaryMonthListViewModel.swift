//
//  WeatherDiaryMonthListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class WeatherDiaryMonthListViewModel: ObservableObject {

    struct Month {
        let name: String
        let number: String
        var isSelected: Bool
    }

    @Published var month: [Month] = []
    var onSelectedMonth: Closure<String>?

    init() {
        self.month = makeMonths()
    }

    func selectMonth(with index: Int) {
        month.indices.forEach { month[$0].isSelected = false }
        month[index].isSelected = true
        onSelectedMonth?(month[index].number)
    }

    func makeMonths() -> [Month] {
        let month: [Month] = monthNames.enumerated().compactMap { result -> Month in
            let number = (result.offset + 1).toStringNumber()
            return .init(name: result.element, number: number, isSelected: UserDefaultsService.shared.dyaryMonth == number)
        }
        var sorted = month
        month.forEach { _ in
            guard sorted.first?.isSelected == false else { return }
            sorted.append(sorted.removeFirst())
        }
        return sorted
    }

    var monthNames: [String] {
        ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    }
}

fileprivate extension Int {

    func toStringNumber() -> String {
        var string = "0\(self)"
        if string.count > 2 {
            string.removeFirst()
        }

        return string
    }

}
