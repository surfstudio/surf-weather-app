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

    @Published private(set) var state: State = .content("Воронеж")

}

// MARK: - Actions

extension LocationHeaderViewModel {

    func buttonAction() {
        print("Location button tapped")
    }

}
