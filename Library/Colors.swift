//
//  File.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

extension Color {

    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }

    static func | (_ lightColor: Color, _ darkColor: Color) -> Color {
        let lightUiColor = UIColor(lightColor)
        let darkUiColor = UIColor(darkColor)
        return Color(UIColor { $0.userInterfaceStyle == .light ? lightUiColor : darkUiColor })
    }
}

extension Color {

    // MARK: - Light

    static var lightBackground: Color {
        Color(0xFFFFFF)
    }

    static var lightBackground2: Color {
        Color(0xEFF1F2)
    }

    static var lightText: Color {
        Color(0x1F2B35)
    }

    static var lightText2: Color {
        Color(0xAEB7C2)
    }

    static var lightBlue: Color {
        Color(0x1288F4)
    }

    static var lightBlue2: Color {
        Color(0x15C0F6)
    }

    // MARK: - Dark

    static var darkWhite: Color {
        Color(0xFFFFFF, alpha: 0.9)
    }

    static var darkText2: Color {
        Color(0x83898F)
    }

    static var darkText: Color {
        Color(0x5F6871)
    }

    static var darkBackground2: Color {
        Color(0x1F2B37)
    }

    static var darkBackground: Color {
        Color(0x081B24)
    }

    static var darkEtirItems: Color {
        Color(0x03151F)
    }

    static var darkPurple: Color {
        Color(0x865BFB)
    }

}
