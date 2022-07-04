//
//  MainScreenForecastJournalView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 04.03.2022.
//

import SwiftUI

struct MainScreenForecastJournalView: View {

    // MARK: - States

    @State var isHovered = false

    // MARK: - Views

    var body: some View {
        NavigationLink(destination: WeatherDiaryView(viewModel: .init())) {
            buttonView
        }
        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
    }

    var buttonView: some View {
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
