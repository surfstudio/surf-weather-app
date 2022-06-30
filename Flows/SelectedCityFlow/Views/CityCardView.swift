//
//  CityCardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 11.05.2022.
//

import SwiftUI

struct CityCardView: View {

    // MARK: - Nested

    struct Model: Hashable {
        var id: Int
        var isSelected: Bool
        let temperature: String
        let time: String
        let city: String
        let imageName: String
    }

    // MARK: - Properties

    @State var model: Model
    @State var isLightMode = UserDefaultsService.shared.isLightMode

    // MARK: - Views

    var body: some View {
        ZStack(alignment: .leading) {
            if model.isSelected {
                Image(isLightMode ? "cardBackgroundLight" : "cardBackgroundDark", bundle: nil)
            }
            VStack(alignment: .leading) {
                topView
                cityView
                Spacer()
                temteratureView
            }
            .padding()
            Image(model.imageName, bundle: nil).position(x: 145, y: 125)
        }
        .background(isLightMode ? Color.white : Color.darkBackground)
        .frame(width: 156, height: 152, alignment: .leading)
        .cornerRadius(24)
        .clipped()
    }

    var topView: some View {
        if model.isSelected {
            return Text("Вы здесь")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(model.isSelected || !isLightMode ? .white : .black)
        } else {
            return Text(model.time)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.blue)
        }
    }

    var cityView: some View {
        Text(model.city)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(model.isSelected || !isLightMode ? .white : .black)
    }

    var temteratureView: some View {
        HStack(spacing: .zero) {
            Text(model.temperature)
                .font(.system(size: 44, weight: .heavy))
                .foregroundColor(model.isSelected || !isLightMode ? .white : .black)
            Text("°")
                .font(.system(size: 44, weight: .heavy))
                .foregroundColor(model.isSelected || !isLightMode ? .white : .black)
        }
    }

}

struct CityCardView_Previews: PreviewProvider {
    static var previews: some View {
        CityCardView(model: .init(id: 1, isSelected: false, temperature: "20", time: "10:00", city: "Воронеж", imageName: "sun"))
    }
}
