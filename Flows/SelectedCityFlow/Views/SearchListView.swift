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

    var body: some View {
        VStack {
            searchView
            locationListView
            Spacer()
        }
        .padding()
    }

    var searchView: some View {
        HStack {
            SearchBarView(searchText: $viewModel.searchText)
            Button {
                presentingModal.toggle()
            } label: {
                Text("Отмена")
            }
        }
    }

    var locationListView: some View {
        VStack(alignment: .leading, spacing: 36) {
            ForEach(0..<viewModel.locations.count, id: \.self) { index in
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
        }.padding(.top, 18.0)
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
