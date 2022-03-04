//
//  MainScreenForecastView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

struct MainScreenForecastView: View {

    // MARK: - States

    @State var selctedSegment: Int = 1

    // MARK: - Views

    var body: some View {
        VStack(alignment: .leading) {
            titleView
            contentView
        }
        .padding(EdgeInsets(top: 22,
                            leading: 16,
                            bottom: 0,
                            trailing: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(color: Color(.black.withAlphaComponent(0.08)), radius: 12, x: 0, y: 0)
    }

    var titleView: some View {
        Text("Прогноз погоды")
            .font(Font.system(size: 24, weight: .semibold))
            .foregroundColor(.lightText | .darkWhite)
    }

    var contentView: some View {
        VStack {
            pickerView
            listView
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 8, trailing: 16))
        .background(Color.lightBackground | Color.darkBackground2)
        .cornerRadius(16)
    }

    var pickerView: some View {
        SegmentedPickerView(selected: $selctedSegment, elements: ["Архив", "5 дней"])
    }

    var listView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ForEach(0..<5) { _ in
                MainScreenForecastListItemView(viewModel: .init(isSelected: false))
            }
        }
    }

}

struct MainScreenForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainScreenForecastView()
                .preferredColorScheme(.light)
                .previewInterfaceOrientation(.portrait)
            MainScreenForecastView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portrait)
        }
    }
}
