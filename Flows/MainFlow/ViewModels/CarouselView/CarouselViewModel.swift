//
//  CarouselViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation

final class CarouselViewModel {

    static let hourly: [HourlyCardView.Model] = [
        .init(time: "12:00", temperature: "20", isSelected: false),
        .init(time: "13:00", temperature: "25", isSelected: true),
        .init(time: "14:00", temperature: "14", isSelected: false),
        .init(time: "15:00", temperature: "8", isSelected: false),
        .init(time: "16:00", temperature: "15", isSelected: false),
        .init(time: "17:00", temperature: "8", isSelected: false),
        .init(time: "18:00", temperature: "15", isSelected: false),
        .init(time: "19:00", temperature: "8", isSelected: false),
        .init(time: "20:00", temperature: "15", isSelected: false)
    ]
    let cardViewModels: [CardViewModel] = [
        .init(model: .init(id: 0, dayly: "Понедельник", temperature: "23", sky: "Солнечно", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 1, dayly: "Вторник", temperature: "10", sky: "Пасмурно", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 2, dayly: "Среда", temperature: "21", sky: "Солнечно", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 3, dayly: "Четверг", temperature: "15", sky: "Дождливо", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 4, dayly: "Пятница", temperature: "19", sky: "Солнечно", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 5, dayly: "Суббота", temperature: "25", sky: "Солнечно", hourly: CarouselViewModel.hourly)),
        .init(model: .init(id: 6, dayly: "Воскресенье", temperature: "23", sky: "Солнечно", hourly: CarouselViewModel.hourly))
    ]
}
