//
//  CardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct CardView: View {

    @State var isLightMode = UserDefaultsService.shared.isLightMode
    private var items: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .gray, .brown]

    var body: some View {
        ZStack {
            Image(isLightMode ? "card_background_light" : "card_background_dark", bundle: nil)
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0 ..< items.count) { index in
                            makeTempSmallView()
                                .frame(width: 68, height: 112)
                        }
                    }
                }.padding()
            }
        }.cornerRadius(32)
    }

    func makeTempSmallView() -> some View {
        VStack(spacing: 8) {
            Text("13:00")
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
            Text("Четверг, 9 сентября")
                .foregroundColor(.white.opacity(0.64))
                .font(Font(.init(.system, size: 12)))
            HStack(alignment: .top, spacing: 8) {
                Text("18")
                    .foregroundColor(.white)
                    .font(Font(.init(.system, size: 72)))
                Text("&deg;")
                    .foregroundColor(.white.opacity(0.64))
                    .font(Font(.init(.system, size: 72)))
                    .padding(EdgeInsets(top: -3, leading: 0, bottom: 0, trailing: 0))
            }
            Text("Солнечно")
                .foregroundColor(.white)
                .font(Font(.init(.system, size: 24)))
        }
    }

}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
