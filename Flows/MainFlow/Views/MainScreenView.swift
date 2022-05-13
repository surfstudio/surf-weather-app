//
//  MainScreenView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import SwiftUI

struct MainScreenView: View {

    // MARK: - Properties

    let viewModel: MainScreenViewModel

    // MARK: - Views

    var body: some View {
        ScrollView {
            LocationHeaderView(viewModel: viewModel.locationViewModel)
            Rectangle()
                .frame(height: 392, alignment: .top)
                .foregroundColor(.gray)
            MainScreenForecastView(viewModel: viewModel.forecastViewModel)
            MainScreenForecastJournalView()
        }
        .background(Color.lightBackground | .darkBackground)
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(viewModel: .init(serviceAssembly: .init()))
    }
}
