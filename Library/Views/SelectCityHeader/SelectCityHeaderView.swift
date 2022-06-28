//
//  SelectCityHeaderView.swift
//  SurfWeatherApp
//
//  Created by porohov on 11.05.2022.
//

import SwiftUI

struct SelectCityHeaderView: View {

    // MARK: - Properties

    var viewModel: SelectCityHeaderViewModel
    @ObservedObject var mainHeaderViewModel: LocationHeaderViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var isChangeMode: Bool

    let selectedCity = UserDefaultsService.shared.selectedCity

    // MARK: - Views

    var body: some View {
        HStack {
            backButton
            Spacer()
            editButton
        }
    }

    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            mainHeaderViewModel.state = .content(selectedCity?.cityName ?? "Воронеж")
        }, label: {
            makeButtonView(with: Image("left-arrow", bundle: nil))
        })
    }

    var editButton: some View {
        Button(action: {
            viewModel.editButtonAction()
            isChangeMode.toggle()
        }, label: {
            makeButtonView(with: Image("edit", bundle: nil))
        })
    }

    func makeButtonView(with image: Image) -> some View {
        ZStack {

            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(.lightBackground | .darkBackground)
                .overlay(
                    Circle()
                        .stroke(.lightBackground2 | .darkBackground2, lineWidth: 1)
                )

            image
            .frame(width: 14, height: 14, alignment: .center)
        }
        .frame(width: 40, height: 40, alignment: .center)
    }

}

struct SelectCityHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let assembly = ServicesAssemblyFactory()
        SelectCityHeaderView(
            viewModel: SelectCityHeaderViewModel(),
            mainHeaderViewModel: .init(weatherNetworkService: assembly.weatherNetworkService,
                                       locationNetworkService: assembly.locationNetworkService,
                                       weatherStorageService: assembly.weatherStorageService),
            isChangeMode: .constant(false))
    }
}
