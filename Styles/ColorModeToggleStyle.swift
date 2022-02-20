//
//  ColorModeToggleStyle.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import SwiftUI

struct ColorModeToggleStyle: ToggleStyle {

    // MARK: - Constants

    private enum Constants {
        static let width: CGFloat = 56
        static let height: CGFloat = 32
        static let circleSide: CGFloat = 28
        static let lightPosition: CGFloat = 40
        static let darkPosition: CGFloat = 16
    }

    // MARK: - Properties

    @State private var position: CGFloat

    // MARK: - Initialization

    init(isOn: Bool) {
        position = isOn ? Constants.lightPosition : Constants.darkPosition
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        let image: Image = configuration.isOn ? Image("toggle-light") : Image("toggle-dark")
        position = configuration.isOn ? Constants.lightPosition : Constants.darkPosition

        return HStack {
            ZStack {
                Capsule()
                    .frame(width: 56, height: 32, alignment: .center)
                    .background(
                        image
                    )
                HStack {
                    Circle()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .foregroundColor(.white)
                        .position(x: position, y: 16)
                }
            }
            .foregroundColor(.clear)
            .frame(width: 56, height: 32, alignment: .center)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    position = !configuration.isOn ? Constants.lightPosition : Constants.darkPosition
                }
                configuration.isOn.toggle()
            }
        }

    }
}
