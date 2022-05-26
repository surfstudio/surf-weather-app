//
//  MainCorouselViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Foundation

final class MainCorouselViewModel: ObservableObject {

    static let hourly: [CardView.Hourly] = [
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
    ]

    let items: [CardView.Model] = [
        .init(dayly: "Понедельник", temperature: "23", sky: "Солнечно", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Вторник", temperature: "10", sky: "Пасмурно", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Среда", temperature: "21", sky: "Солнечно", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Четверг", temperature: "15", sky: "Дождливо", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Пятница", temperature: "19", sky: "Солнечно", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Суббота", temperature: "25", sky: "Солнечно", hourly: MainCorouselViewModel.hourly),
        .init(dayly: "Воскресенье", temperature: "23", sky: "Солнечно", hourly: MainCorouselViewModel.hourly),
    ]

}
