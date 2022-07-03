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
                    GeometryReader { makeCarousel(with: $0) }.frame(height: carouselMode == .short ? 200 : 380)
                    MainScreenForecastView(viewModel: viewModel.forecastViewModel)
                    MainScreenForecastJournalView()
                }
                MainScreenPageIndicatorView(viewModel: viewModel.carouselViewModel)
            }
            .modifier(InterfaceStyleModifier())
            .background(Color.lightBackground | .darkBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .animation(.easeInOut(duration: 0.5), value: carouselMode)
        }

    }

    func makeCarousel(with proxy: GeometryProxy) -> some View {
        let topSpace = 110.0
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
        return VStack {
            Spacer()
            CarouselView(cardMode: $carouselMode, viewModel: viewModel.carouselViewModel)
        }
        .shimmer(isActive: viewModel.isLoading)
        .environmentObject(getShimmerConfig(animation: true))
    }

    private func getShimmerConfig(animation: Bool) -> ShimmerConfig {
        let bgColor: Color = (.lightBackground2 | .darkBackground2)
        let config = ShimmerConfig(bgColor: bgColor, fgColor: .clear)
        if animation { config.startAnimation() }
        return config
    }

}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(viewModel: .init(serviceAssembly: ServicesAssemblyFactory()))
    }
}

struct InterfaceStyleModifier: ViewModifier {

    @ObservedObject private var setting = UserDefaultsService.shared

    func body(content: Content) -> some View {
        content.preferredColorScheme(setting.isLightMode ? .light : .dark)
    }
}
