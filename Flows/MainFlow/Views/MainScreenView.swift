//
//  MainScreenView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import SwiftUI

struct MainScreenView: View {

    let serviceAssembly = ServicesAssemblyFactory()

    var body: some View {
        ScrollView {
            LocationHeaderView(viewModel: LocationHeaderViewModel())
            Rectangle()
                .frame(height: 392, alignment: .top)
                .foregroundColor(.gray)
            MainScreenForecastView(viewModel: .init(weatherService: serviceAssembly.weatherNetworkService))
            MainScreenForecastJournalView()
        }
        .background(Color.lightBackground | .darkBackground)
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
