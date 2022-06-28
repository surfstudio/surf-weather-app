//
//  DateFormatter.swift
//  Library
//
//  Created by porohov on 10.02.2022.
//

import Foundation

public enum DateFormat: String {

    case dayMonthYear = "dd.MM.yyyy"
    case dayLongMonthYear = "dd MMMM yyyy"
    case dayLongMonth = "dd MMMM"
    case time = "h:mm"

    public var defaultFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = self.rawValue
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }

    public static func calendarFormatter(format: DateFormat) -> DateFormatter {
        let dateFormatter = format.defaultFormatter
        dateFormatter.calendar = .current
        return dateFormatter
    }

    public static func compareDates(_ first: String, _ second: String, format: DateFormat) -> Bool {
        let formatterDate = calendarFormatter(format: format)
        return formatterDate.date(from: first) ?? Date() < formatterDate.date(from: second) ?? Date()
    }

}

extension Date {

    var weekday: String {
        let calendar = Calendar.current
        let daily = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
        let weekday = calendar.component(.weekday, from: self)

        return daily[weekday - 1]
    }

    var isToday: Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        let currentDay = calendar.component(.weekday, from: Date())

        return weekday == currentDay
    }

}
