//
//  WeatherDiaryForecastView.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import SwiftUI

struct WeatherDiaryForecastListView: View {

    @ObservedObject var viewModel: WeatherDiaryForecastListViewModel

    var body: some View {
        weatherlistView
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 28, trailing: 16))
            .background(Color.lightBackground | Color.darkBackground2)
            .cornerRadius(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .shadow(color: Color(.black.withAlphaComponent(0.08)), radius: 12, x: 0, y: 0)
    }

    var weatherlistView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(viewModel.items.indices) {
                ForecastListItemView(viewModel: viewModel.items[$0])
            }
        }
    }

}

struct WeatherDiaryForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDiaryForecastListView(viewModel: .init())
    }
}