//
//  SearchListView.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import SwiftUI

struct SearchListView: View {

    @ObservedObject var viewModel: LocationListViewModel
    @Binding var presentingModal: Bool
    @FocusState var focusedField: Bool

    var body: some View {
        VStack {
            searchView
            locationListView
            Spacer()
        }
        .padding()
        .background(Color.lightBackground | Color.darkBackground2)
        .onAppear {
            // Без задержки почему то текстовое поле не получает статус первого респондента
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.focusedField = true
            }
        }
    }

    var searchView: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText, focusedField: $focusedField)
            Button {
                presentingModal.toggle()
            } label: {
                Text("Отмена")
            }
        }
    }

    var locationListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {
                ForEach(0..<viewModel.locations.count, id: \.self) { index in
                    makeButton(with: index)
                }
            }.padding(.top, 18.0)
        }
    }

    func makeButton(with index: Int) -> some View {
        Button {
            viewModel.addNewCity(with: index)
            UIApplication.shared.endEditing()
            presentingModal.toggle()
        } label: {
            HStack {
                Text(viewModel.locations[index])
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .foregroundColor(.black | .white)
                Spacer()
            }
        }
    }

}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListView(
            viewModel: .init(locationService: ServicesAssemblyFactory().locationNetworkService,
                             weatherService: ServicesAssemblyFactory().weatherNetworkService),
            presentingModal: .constant(false)
        )
    }
}
