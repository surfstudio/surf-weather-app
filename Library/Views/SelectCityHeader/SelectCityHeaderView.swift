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
            if !isChangeMode {
                backButton
            }
            Spacer()
            editButton
        }
    }

    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            mainHeaderViewModel.state = .content(selectedCity?.cityName ?? "Воронеж")
        }, label: {
            RoundButtonView(image: Image("left-arrow", bundle: nil))
        })
    }

    var editButton: some View {
        Button(action: {
            viewModel.editButtonAction()
            isChangeMode.toggle()
        }, label: {
            if isChangeMode {
                Text("Готово").frame(height: 40).foregroundColor(.lightBlue | .violetTextColor)
            } else {
                RoundButtonView(image: Image("edit", bundle: nil))
            }
        })
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
