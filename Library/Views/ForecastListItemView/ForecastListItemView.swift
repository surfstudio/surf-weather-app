//
//  ForecastListItemView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

struct ForecastListItemView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ForecastListItemViewModel

    // MARK: - Private Properties

    private var dayColor: Color {
        let allocateColor: Color = .lightBlue | .darkPurple
        let noramalColor: Color = .lightText | .darkWhite
        return viewModel.isNeedDayAllocate ? allocateColor : noramalColor
    }

    // MARK: - Views

    var body: some View {
        VStack {
            headView
            bottomView

            if viewModel.isNeedSeparator {
                separatorView
            }

        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    var headView: some View {
        HStack {
            Text(viewModel.model.weekday)
                .font(.system(size: 16))
                .foregroundColor(dayColor) +
            Text(", \(viewModel.model.date)")
                .font(.system(size: 16))
                .foregroundColor(.lightText2 | .darkText)

            Spacer()

            Button(action: {
                viewModel.selectItemAction()
            }) {
                if viewModel.isSelected {
                    Image("selected", bundle: nil)
                } else {
                    Image("deselected", bundle: nil)
                }
            }
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 6, trailing: 0))
    }

    var bottomView: some View {
        HStack(spacing: 0) {
            Text(viewModel.model.temperature)
                .font(.system(size: 16))
                .foregroundColor(.lightText | .darkWhite)
            Spacer()
                .frame(width: 20)
            Image(viewModel.model.weatherImage, bundle: nil)
                .renderingMode(.template)
                .frame(width: 16, height: 16)
                .tint(.lightText | .darkWhite)
            Spacer()
                .frame(width: 8)
            Text(viewModel.model.description)
                .font(.system(size: 12))
                .foregroundColor(.lightText | .darkWhite)

            Spacer()
            Image("wind", bundle: nil)
            Spacer()
                .frame(width: 4)
            Text(viewModel.model.wind)
                .font(.system(size: 12))
                .foregroundColor(.lightText2 | .darkText)
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

}

// MARK: - Model

extension ForecastListItemView {

    struct Model {
        let cityName: String
        let lat: Double
        let lon: Double
        let weekday: String
        let date: String
        let temperature: String
        let weatherImage: String
        let description: String
        let wind: String
    }

}

// MARK: - Preview

struct ForecastListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListItemView(
            viewModel: .init(isSelected: false,
                             model: .init(cityName: "Воронеж",
                                          lat: 25,
                                          lon: 25,
                                          weekday: "Сегодня",
                                          date: "11 апреля",
                                          temperature: "5℃",
                                          weatherImage: "01d",
                                          description: "Сильный ветер",
                                          wind: "7 м/с"),
                             isNeedSeparator: true,
                             isNeedDayAllocate: false,
                             storageService: ServicesAssemblyFactory().weatherStorageService
                            )
        )
    }
}
