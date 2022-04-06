//
//  TemperatureFormatter.swift
//  Library
//
//  Created by porohov on 09.03.2022.
//

import Foundation

public enum TemperatureFormatter {

    // MARK: - Nested

    private enum Constants {
        static let maximumFractionDigits = 2 // Колличество символов после запятой
    }

    // MARK: - Method

    /// Форматирует value в UnitTemperature
    /// Пример 1.24 грамм выведет строку "1.2℃"
    public static func format(with value: Double, unit: UnitTemperature) -> String {
        let unit = Measurement(value: value, unit: unit)

        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.numberFormatter.maximumFractionDigits = Constants.maximumFractionDigits

        return formatter.string(from: unit)
    }

}
