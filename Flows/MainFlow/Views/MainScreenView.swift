//
//  MainScreenView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import SwiftUI

struct MainScreenView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: MainScreenViewModel
    let serviceAssembly = ServicesAssemblyFactory()

    // MARK: - Private Properties

    @State private var carouselMode: CardView.Mode = .long

    // MARK: - Views

    var body: some View {
        NavigationView {
            VStack {
                LocationHeaderView(viewModel: viewModel.locationViewModel)
                ScrollView {
                    GeometryReader { makeCarousel(with: $0) }.frame(height: carouselMode == .short ? 188 : 360)
                    MainScreenForecastView(viewModel: viewModel.forecastViewModel)
                    MainScreenForecastJournalView()
                }
            }
            .background(Color.lightBackground | .darkBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .animation(.easeInOut(duration: 0.5), value: carouselMode)
        }

    }

    func makeCarousel(with proxy: GeometryProxy) -> some View {
        let topSpace = 80.0
        let offset = proxy.frame(in: .global).minY - topSpace
        DispatchQueue.main.async {
            if carouselMode == .long && offset < .zero {
                self.carouselMode = .short
                self.viewModel.carouselViewModel.updateIsNeeded = true
            } else if carouselMode == .short && offset > .zero {
                self.carouselMode = .long
                self.viewModel.carouselViewModel.updateIsNeeded = true
            }
        }
        return CarouselView(cardMode: $carouselMode, viewModel: viewModel.carouselViewModel)
    }

}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(viewModel: .init(serviceAssembly: ServicesAssemblyFactory()))
    }
}
