//
//  MainScreenPageIndicatorView.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import Foundation
import SwiftUI

struct MainScreenPageIndicatorView: View {

    // MARK: - Constants

    private enum Constants {
        static let selectItemColor = Color.lightBlue | Color.violetColor
        static let deselectItemColor = Color.lightBackground2 | Color.darkBackground2
    }

    // MARK: - Properties

    @ObservedObject var viewModel: CarouselViewModel

    // MARK: - Private Properties

    @ObservedObject private var storage = UserDefaultsService.shared

    // MARK: - Views

    var body: some View {
        HStack {
            ForEach(viewModel.cardViewModels.indices, id: \.self) { index in
                let model = viewModel.cardViewModels[index].model
                let isSelected = storage.selectedCity?.cityName == model.city
                makeCirkle(with: model, isSelected: isSelected, index: index)
            }
        }
    }

    func makeCirkle(with model: CardView.Model, isSelected: Bool, index: Int) -> some View {
        RoundedRectangle(cornerRadius: 4).frame(width: 8, height: 8)
            .foregroundColor(isSelected ? Constants.selectItemColor : Constants.deselectItemColor)
            .onTapGesture {
                viewModel.selectCity(with: model.city)
                viewModel.changePage(with: index)
            }
    }

}
