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
    let serviceAssembly = ServicesAssemblyFactory()

    // MARK: - Views

    var body: some View {
        NavigationView {
            VStack {
                LocationHeaderView(
                    viewModel: LocationHeaderViewModel(),
                    weatherNetworkService: serviceAssembly.weatherNetworkService,
                    locationNetworkService: serviceAssembly.locationNetworkService
                )
                ScrollView {
//                    MainCorouselView(viewModel: viewModel.carouselViewModel)
                    CardView(model: viewModel.carouselViewModel.items.first!).padding()
                    MainScreenForecastView(viewModel: viewModel.forecastViewModel)
                    MainScreenForecastJournalView()
                }
            }
            .background(Color.lightBackground | .darkBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(viewModel: .init(serviceAssembly: ServicesAssemblyFactory()))
    }
}
