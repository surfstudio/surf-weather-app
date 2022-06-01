//
//  ScrollIndicatorView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.06.2022.
//

import SwiftUI

struct ScrollIndicatorView: View {

    var itemCount = 7
    @Binding var page: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<itemCount) { index in
                let isSelected = page == index
                Rectangle()
                    .foregroundColor(isSelected ? .white : .white.opacity(0.4))
                    .cornerRadius(isSelected ? 4 : 0)
            }
        }
        .frame(width: 64, height: 4)
        .cornerRadius(4)
    }
}

