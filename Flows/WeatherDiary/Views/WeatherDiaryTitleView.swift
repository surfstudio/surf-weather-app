//
//  WeatherDiaryTitleView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import SwiftUI
import UIKit

struct WeatherDiaryTitleView: View {

    @Binding var presentingModal: Bool
    @ObservedObject var viewModel: WeatherDiaryTitleViewModel

    var body: some View {
        HStack {
            Text("Дневник погоды")
                .font(.system(size: 24, weight: .heavy))
                .multilineTextAlignment(.leading)
                .foregroundColor(.lightText | .white)
            dateButtonView
            Spacer()
        }
        .padding([.leading, .trailing])
    }

    var dateButtonView: some View {
        Button {
            presentingModal.toggle()
        } label: {
            HStack {
                Text(viewModel.selectedYear)
                    .font(.system(size: 24, weight: .heavy))
                    .tint(.lightBlue | .darkPurple)
                Image("down-arrow", bundle: nil)
            }
        }
    }

}

struct WeatherDiaryTitleView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDiaryTitleView(presentingModal: .constant(false), viewModel: .init())
    }
}
