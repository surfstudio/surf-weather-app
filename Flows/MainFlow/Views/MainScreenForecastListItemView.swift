//
//  MainScreenForecastListItemView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

struct MainScreenForecastListItemView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: MainScreenForecastListItemViewModel

    // MARK: - Views

    var body: some View {
        VStack {
            headView
            bottomView
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.clear)
                .background(
                    gradientView
                )
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    var headView: some View {
        HStack {
            Text("Сегодня")
                .font(.system(size: 16))
                .foregroundColor(.lightText | .darkWhite) +
            Text(", 9 сен")
                .font(.system(size: 16))
                .foregroundColor(.lightText2 | .darkText)

            Spacer()

            Button(action: {}) {
                Image("deselected", bundle: nil)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 6, trailing: 0))
    }

    var bottomView: some View {
        HStack(spacing: 0) {
            Text("16&deg;")
                .font(.system(size: 16))
                .foregroundColor(.lightText | .darkWhite)
            Spacer()
                .frame(width: 20)
            Image("weather-sun", bundle: nil)
                .renderingMode(.template)
                .tint(.lightText | .darkWhite)
            Spacer()
                .frame(width: 8)
            Text("Ясно")
                .font(.system(size: 12))
                .foregroundColor(.lightText | .darkWhite)

            Spacer()
            Image("wind", bundle: nil)
            Spacer()
                .frame(width: 4)
            Text("2,1 м/с, СВ")
                .font(.system(size: 12))
                .foregroundColor(.lightText2 | .darkText)
        }
    }

    var gradientView: some View {
        LinearGradient(colors: [
            .lightBackground | .darkBackground2,
            .lightBackground2 | .darkBackground,
            .lightBackground | .darkBackground2],
                       startPoint: .leading,
                       endPoint: .trailing)
    }

}

struct MainScreenForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenForecastListItemView(viewModel: .init(isSelected: false))
    }
}
