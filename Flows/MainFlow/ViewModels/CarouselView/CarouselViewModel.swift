//
//  CarouselViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation
import SwiftUI

final class CarouselViewModel: ObservableObject {

    @Published var updateIsNeeded = false
    @Published var cardViewModels: [CardViewModel] = []

    init() {
        self.cardViewModels = [
            .init(model: .init(dayly: "Понедельник, 1 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Вторник, 2 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Среда, 3 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Четверг, 4 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Пятница, 5 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Суббота, 6 мая", temperature: "25", image: .sunMidle, hourly: hourly)),
            .init(model: .init(dayly: "Воскресенье, 7 мая", temperature: "25", image: .sunMidle, hourly: hourly))
        ]
        withAnimation { self.updateIsNeeded = true }
    }

}

let hourly: [HourlyCardView.Model] = [
    .init(time: "12:00", temperature: "20", image: .sun, isSelected: false),
    .init(time: "13:00", temperature: "25", image: .sunMidle, isSelected: true),
    .init(time: "14:00", temperature: "14", image: .rain, isSelected: false),
    .init(time: "15:00", temperature: "8", image: .storm, isSelected: false),
    .init(time: "16:00", temperature: "15", image: .cloudy, isSelected: false),
    .init(time: "17:00", temperature: "8", image: .cloudy, isSelected: false),
    .init(time: "18:00", temperature: "15", image: .sunMidle, isSelected: false),
    .init(time: "19:00", temperature: "8", image: .sunMidle, isSelected: false),
    .init(time: "20:00", temperature: "15", image: .sun, isSelected: false)
]
