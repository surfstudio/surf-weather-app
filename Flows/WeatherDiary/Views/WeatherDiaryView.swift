//
//  WeatherDiaryView.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.06.2022.
//

import SwiftUI

struct WeatherDiaryView: View {

    private enum Constant {
        static let spacing = 38.0
    }

    @State var showingBottomSheet = false
    @ObservedObject var viewModel: WeatherDiaryViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: Constant.spacing) {
            backButtonView
            WeatherDiaryTitleView(presentingModal: $showingBottomSheet,
                                  viewModel: viewModel.weatherDiaryTitleViewModel)
            WeatherDiaryMonthListView(viewModel: viewModel.weatherDiaryMonthListViewModel)
            forecastListView
        }
        .background(Color.lightBackground | Color.darkBackground)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .bottomSheet(isOpen: $showingBottomSheet, title: "Выбор периода", height: 350) {
            DatePickerView(viewModel: viewModel.datePickerViewModel, isShow: $showingBottomSheet)
        }
    }

    var backButtonView: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            RoundButtonView(image: Image("left-arrow", bundle: nil))
        }).padding([.leading, .top])
    }

    var forecastListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            WeatherDiaryForecastListView(viewModel: viewModel.weatherDiaryForecastListViewModel).padding()
            Spacer()
        }.padding(.top, -22) // Для корректного показа тени
    }

}

struct WeatherDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDiaryView(viewModel: .init())
    }
}
