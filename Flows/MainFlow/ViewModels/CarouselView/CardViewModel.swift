//
//  CardViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation

final class CardViewModel: ObservableObject, Identifiable {

    @Published var model: CardView.Model

    init(model: CardView.Model) {
        self.model = model
    }

    func selectHourlyWeather(with selected: HourlyCardView.Model) {
        updateModel(with: selected)
    }

}

private extension CardViewModel {

    func updateModel(with selected: HourlyCardView.Model) {
        var newModel = model
        newModel.temperature = selected.temperature
        newModel.image = selected.image
        for (index, hourModel) in newModel.hourly.enumerated() {
            newModel.hourly[index].isSelected = hourModel == selected
        }

        self.model = newModel
    }

}
