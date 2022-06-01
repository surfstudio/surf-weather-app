//
//  ScrollIndicatorView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.06.2022.
//

import SwiftUI

struct ScrollIndicatorView: View {

    @Binding var progres: CGFloat
    var visibleItemCount: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 64, height: 4)
                .cornerRadius(4)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 20, height: 4)
                .cornerRadius(4)
                .padding(.leading, progres * visibleItemCount)
        }
    }
}

