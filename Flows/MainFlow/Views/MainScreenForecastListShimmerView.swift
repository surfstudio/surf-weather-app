//
//  MainScreenForecastListShimmerView.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import SwiftUI

struct MainScreenForecastListShimmerView: View {

    // MARK: - Properties

    let isSelected: Bool

    // MARK: - Views

    var body: some View {
        VStack {
            headView
            bottomView
            separatorView

        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    var headView: some View {
        let shimmeringConfig = getShimmerConfig(animation: true, opacity: isSelected ? 0.3 : 1)
        let selectedBackground: Color = .blue | .purple
        let background: Color = .white | .darkBackground2

        return HStack {
            RoundedRectangle(cornerRadius: 8).frame(width: 124, height: 16)
                .foregroundColor(isSelected ? selectedBackground : background)
                .shimmer(isActive: true)
                .environmentObject(shimmeringConfig)
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 6, trailing: 0))
    }

    var bottomView: some View {
        let shimmeringConfig = getShimmerConfig(animation: true)

        return HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 6).frame(width: 164, height: 12)
                .foregroundColor(.white | .darkBackground2)
                .shimmer(isActive: true)
                .environmentObject(shimmeringConfig)
            Spacer()
            RoundedRectangle(cornerRadius: 6).frame(width: 74, height: 12)
                .foregroundColor(.white | .darkBackground2)
                .shimmer(isActive: true)
                .environmentObject(shimmeringConfig)
        }
    }

    var separatorView: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.clear)
            .background(
                LinearGradient(colors: [
                    .lightBackground | .darkBackground2,
                    .lightBackground2 | .darkBackground,
                    .lightBackground | .darkBackground2],
                               startPoint: .leading,
                               endPoint: .trailing)
            )
    }

    func getShimmerConfig(animation: Bool, opacity: Double = 1) -> ShimmerConfig {
        let bgColor: Color = (.lightBackground2.opacity(opacity) | .darkBackground2.opacity(opacity))
        let config = ShimmerConfig(bgColor: bgColor, fgColor: .clear)
        if animation { config.startAnimation() }
        return config
    }

}

// MARK: - Preview

struct MainScreenForecastListShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenForecastListShimmerView(isSelected: false)
    }
}
