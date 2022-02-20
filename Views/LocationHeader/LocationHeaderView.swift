//
//  LocationHeaderView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 20.02.2022.
//

import SwiftUI

struct LocationHeaderView: View {

    // MARK: - Properties

    @StateObject var viewModel: LocationHeaderViewModel

    // MARK: - Views

    var body: some View {
        HStack {
            button

            switch viewModel.state {
            case .loading:
                infoView(with: "Loading")
            case .content(let cityName):
                infoView(with: cityName)
            case .empty:
                EmptyView()
            }

            Spacer()
            Capsule()
                .frame(width: 65, height: 32, alignment: .center)
                .foregroundColor(.blue)
        }
        .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
    }

    var button: some View {
        Button(action: {
            viewModel.buttonAction()
        }, label: {
            buttonView
        })
    }

    var buttonView: some View {
        ZStack {

            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(.white)
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                )

            VStack(alignment: .center, spacing: 4) {
                HStack(alignment: .center, spacing: 4) {
                    smallCircle
                    smallCircle
                }
                HStack(alignment: .center, spacing: 4) {
                    smallCircle
                    smallCircle
                }
            }
            .frame(width: 14, height: 14, alignment: .center)
        }
        .frame(width: 40, height: 40, alignment: .center)
    }

    var smallCircle: some View {
        RoundedRectangle(cornerRadius: 2.5, style: .continuous)
            .foregroundColor(.blue)
            .frame(width: 5, height: 5, alignment: .center)
    }

    // MARK: - View Methods

    @ViewBuilder
    func infoView(with cityName: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Вы здесь")
                .foregroundColor(.gray)
                .font(Font.system(size: 12))
            Text(cityName)
                .font(Font.system(size: 16, weight: .semibold))
        }
    }

}

struct LocationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LocationHeaderView(viewModel: LocationHeaderViewModel())
    }
}
