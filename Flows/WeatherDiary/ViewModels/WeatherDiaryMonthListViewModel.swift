//
//  WeatherDiaryMonthListViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import Foundation

final class WeatherDiaryMonthListViewModel: ObservableObject {

    @Published var month: [(String, Bool)]

    init() {
        month = [("Январь", false), ("Февраль", true), ("Март", false), ("Апрель", false), ("Май", false), ("Июнь", false)]
    }

    func selectMonth(with index: Int) {
        month.indices.forEach { month[$0].1 = false }
        month[index].1 = true
    }

}
