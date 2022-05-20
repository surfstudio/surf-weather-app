//
//  MainScreenForecastView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

struct MainScreenForecastView: View {

    // MARK: - States

    @ObservedObject var viewModel: MainScreenForecastViewModel

    // MARK: - Views

    var body: some View {
        VStack(alignment: .leading) {
            titleView
            contentView
        }
        .padding(EdgeInsets(top: 22,
                            leading: 16,
                            bottom: 0,
                            trailing: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(color: Color(.black.withAlphaComponent(0.08)), radius: 12, x: 0, y: 0)
        .onAppear { viewModel.loadData() }
    }

    var titleView: some View {
        Text("Прогноз погоды")
            .font(Font.system(size: 24, weight: .semibold))
            .foregroundColor(.lightText | .darkWhite)
    }

    var contentView: some View {
        VStack {
            pickerView
            listView
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 28, trailing: 16))
        .background(Color.lightBackground | Color.darkBackground2)
        .cornerRadius(16)
    }

    var pickerView: some View {
        SegmentedPickerView(selected: $viewModel.selectedList, elements: ["Архив", "5 дней"])
    }

    var listView: some View {
        return viewModel.items.isEmpty
        ? AnyView(shimmeringListView)
        : AnyView(weatherlistView)
    }

    var weatherlistView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(viewModel.items.indices, id: \.self) {
                MainScreenForecastListItemView(viewModel: viewModel.items[$0])
            }
        }
        .frame(minHeight: 430)
    }

    var shimmeringListView: some View {
        ForEach(0...4, id: \.self) { index in
            MainScreenForecastListShimmerView(isSelected: index == .zero)
        }
    }

}

struct MainScreenForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainScreenForecastView(viewModel: .init(weatherService: ServicesAssemblyFactory().weatherNetworkService))
                .preferredColorScheme(.light)
                .previewInterfaceOrientation(.portrait)
            MainScreenForecastView(viewModel: .init(weatherService: ServicesAssemblyFactory().weatherNetworkService))
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
