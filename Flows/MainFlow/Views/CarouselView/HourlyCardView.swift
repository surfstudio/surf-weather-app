//
//  HourlyCardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation
import SwiftUI

struct HourlyCardView: View {

    struct Model: Hashable {
        let time: String
        let temperature: String
        let image: Assets.Weather
        var isSelected: Bool
    }

    let model: Model
    let size: CGSize

    var body: some View {
        VStack(spacing: 8) {
            Text(model.time)
                .font(Font(.init(.system, size: 14)))
                .foregroundColor(model.isSelected ? .violetTextColor : .white.opacity(0.64))
            Image(model.image.medium, bundle: nil).resizable()
                .frame(width: 32, height: 32)
            Text("\(model.temperature)&deg;")
                .font(Font(.init(.system, size: 20)))
                .foregroundColor(model.isSelected ? .black : .white)
        }
        .frame(width: size.width, height: size.height)
        .background(
            model.isSelected ? Color.white : Color.clear
        )
        .cornerRadius(16)
    }

}
