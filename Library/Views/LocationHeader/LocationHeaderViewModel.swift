//
//  LocationHeaderViewModel.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import Foundation

final class LocationHeaderViewModel: ObservableObject {

    // MARK: - Nested Types

    enum State {
        case empty
        case loading
        case content(String)
    }

    // MARK: - States

    @Published var state: State = .content(UserDefaultsService.shared.selectedCity?.cityName ?? "")

}

// MARK: - Actions

extension LocationHeaderViewModel {

    func buttonAction() {
        print("Location button tapped")
    }

}
