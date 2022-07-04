//
//  WeatherDiaryMonthListView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import SwiftUI

struct WeatherDiaryMonthListView: View {

    private enum Constant {
        static let monthItemHeight = 48.0
        static let monthItemRadius = 16.0
        static let borderWidth = 1.33
        static let spacing = 16.0
    }

    @ObservedObject var viewModel: WeatherDiaryMonthListViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.month.indices) {
                    makeMonthView(with: $0)
                }
            }
            .frame(height: Constant.monthItemHeight)
            .padding(.leading, Constant.borderWidth + Constant.spacing)
            .padding(.trailing, Constant.borderWidth + Constant.spacing)
        }
    }

    func makeMonthView(with index: Int) -> some View {
        let selectedColor = Color.lightBlue | Color.darkPurple
        let deselectColor = Color.lightBackground2 | Color.darkBackground2
        let isSelected = viewModel.month[index].isSelected

        return Button {
            viewModel.selectMonth(with: index)
        } label: {
            Text(viewModel.month[index].name)
                .foregroundColor(.black | .white)
                .padding()
                .frame(height: Constant.monthItemHeight - Constant.borderWidth)
                .overlay(
                    RoundedRectangle(cornerRadius: Constant.monthItemRadius)
                        .stroke(isSelected ? selectedColor : deselectColor, lineWidth: Constant.borderWidth)
                )
        }
    }

}

struct WeatherDiaryMonthListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDiaryMonthListView(viewModel: .init())
    }
}
