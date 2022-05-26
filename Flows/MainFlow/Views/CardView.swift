//
//  CardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct CardView: View {

    struct Hourly: Hashable {
        let time: String
        let temperature: String
    }

    struct Model: Identifiable {
        let id: UUID = .init()
        let dayly: String
        let temperature: String
        let sky: String
        let hourly: [Hourly]
    }

    let model: Model

    var body: some View {
        ZStack {
            Image(UserDefaultsService.shared.isLightMode ? "card_background_light" : "card_background_dark", bundle: nil)
                .resizable()
            VStack {
                HStack(alignment: .top) {
                    makeTempBigView().padding()
                    Spacer()
                    Image("sun_big", bundle: nil)
                }
                Spacer()
                Image("separator", bundle: nil)
                Spacer()
                hourlyWeatherListView
            }
        }.cornerRadius(32)
    }

    var hourlyWeatherListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(model.hourly, id: \.self) { weather in
                    makeTempSmallView(weather: weather)
                        .frame(width: 68, height: 112)
                }
            }
        }.padding()
    }

    func makeTempSmallView(weather: Hourly) -> some View {
        VStack(spacing: 8) {
            Text(weather.time)
                .font(Font(.init(.system, size: 14)))
                .foregroundColor(.white.opacity(0.64))
            Image("sun", bundle: nil).resizable().frame(width: 32, height: 32)
            Text("19&deg;")
                .font(Font(.init(.system, size: 20)))
                .foregroundColor(.white)
        }
    }

    func makeTempBigView() -> some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(model.dayly)
                .foregroundColor(.white.opacity(0.64))
                .font(Font(.init(.system, size: 12)))
            HStack(alignment: .top, spacing: 8) {
                Text(model.temperature)
                    .foregroundColor(.white)
                    .font(Font(.init(.system, size: 72)))
                Text("&deg;")
                    .foregroundColor(.white.opacity(0.64))
                    .font(Font(.init(.system, size: 72)))
                    .padding(EdgeInsets(top: -3, leading: 0, bottom: 0, trailing: 0))
            }
            Text(model.sky)
                .foregroundColor(.white)
                .font(Font(.init(.system, size: 24)))
        }
    }

}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(model: .init(dayly: "Четверг", temperature: "23", sky: "Солнечно", hourly: []))
    }
}
