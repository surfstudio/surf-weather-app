//
//  PagerView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct PagerView: View {

    // MARK: - Constants

    private enum Constants {
        static let itemPadding: CGFloat = 16
        static let itemWidth: CGFloat = UIScreen.main.bounds.width - 48
    }

    // MARK: - Private Properties

    @State var activePageIndex: Int = 0

    static let hourly: [CardView.Hourly] = [
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
        .init(time: "12:00", temperature: "20"),
    ]
    let items: [CardView.Model] = [
        .init(dayly: "Понедельник", temperature: "23", sky: "Солнечно", hourly: Self.hourly),
        .init(dayly: "Вторник", temperature: "10", sky: "Пасмурно", hourly: Self.hourly),
        .init(dayly: "Среда", temperature: "21", sky: "Солнечно", hourly: Self.hourly),
        .init(dayly: "Четверг", temperature: "15", sky: "Дождливо", hourly: Self.hourly),
        .init(dayly: "Пятница", temperature: "19", sky: "Солнечно", hourly: Self.hourly),
        .init(dayly: "Суббота", temperature: "25", sky: "Солнечно", hourly: Self.hourly),
        .init(dayly: "Воскресенье", temperature: "23", sky: "Солнечно", hourly: Self.hourly),
    ]

    // MARK: - Body

    var body: some View {
        ScalePageView(items) { item in
            CardView(model: item)
        }
        .pagePadding(left: .absolute(30), right: .absolute(30))
        .frame(height: 360)
    }

}

// MARK: - Preview

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView()
    }
}
