//
//  RoundButtonView.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import SwiftUI

struct RoundButtonView: View {

    var image: Image

    var body: some View {
        ZStack {

            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(.lightBackground | .darkBackground)
                .overlay(
                    Circle()
                        .stroke(.lightBackground2 | .darkBackground2, lineWidth: 1)
                )

            image
            .frame(width: 14, height: 14, alignment: .center)
        }
        .frame(width: 40, height: 40, alignment: .center)
    }

}
