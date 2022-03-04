//
//  MainScreenForecastJournalView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import SwiftUI

struct MainScreenForecastJournalView: View {

    @State var isHovered = false

    var body: some View {
        Button(action: {}) {
            HStack {
                iconView
                Spacer()
                    .frame(width: 12)
                Text("Дневник учета изменения \nпогодных условий")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.lightText | .darkWhite)
                    .font(.system(size: 14))
                Spacer()
                Image("right-arrow", bundle: nil)
            }
        }
        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }

    var iconView: some View {
        ZStack {
            Circle()
                .foregroundColor(.lightBlue.opacity(0.08) | .darkPurple.opacity(0.12))
                .frame(width: 48, height: 48, alignment: .center)
            Image("journal", bundle: nil)
        }
    }
}

struct MainScreenForecastJournalView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenForecastJournalView()
    }
}
