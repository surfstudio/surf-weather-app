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
                    weatherNetworkService: serviceAssembly.weatherNetworkService
                )
                ScrollView {
                    makeRactangle()
                    MainScreenForecastView(viewModel: viewModel.forecastViewModel)
                    MainScreenForecastJournalView()
                }
            }
            .background(Color.lightBackground | .darkBackground)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }

}

// MARK: - Private Methods

private extension MainScreenView {

    func makeRactangle() -> some View {
        let shimmeringConfig = getShimmerConfig(animation: true)
        return Rectangle()
            .frame(height: 392, alignment: .top)
            .foregroundColor(.lightBackground2)
            .shimmer(isActive: true)
            .environmentObject(shimmeringConfig)
    }

    func getShimmerConfig(animation: Bool) -> ShimmerConfig {
        let config = ShimmerConfig(bgColor: Color.clear, fgColor: Color.clear)
        if animation { config.startAnimation() }
        return config
    }

}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(viewModel: .init(serviceAssembly: .init()))
    }
}
