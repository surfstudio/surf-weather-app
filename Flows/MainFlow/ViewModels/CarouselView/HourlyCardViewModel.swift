//
//  HourlyCardViewModel.swift
//  SurfWeatherApp
//
//  Created by porohov on 31.05.2022.
//

import Foundation

final class HourlyCardViewModel: ObservableObject {

    @Published var model: HourlyCardView.Model
    var onSelected: ((Bool) -> Void)?

    init(model: HourlyCardView.Model) {
        self.model = model
    }

    func select() {
        model.isSelected.toggle()
        onSelected?(model.isSelected)
    }

}
