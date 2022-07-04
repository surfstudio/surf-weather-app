//
//  SelectCityView.swift
//  SurfWeatherApp
//
//  Created by porohov on 11.05.2022.
//

import SwiftUI

struct SelectCityView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: SelectCityViewModel
    @ObservedObject var mainHeaderViewModel: LocationHeaderViewModel

    @State var presentingModal = false
    @State var isChangeMode = false

    // MARK: - Initialization

    init(viewModel: SelectCityViewModel, mainHeaderViewModel: LocationHeaderViewModel) {
        self.viewModel = viewModel
        self.mainHeaderViewModel = mainHeaderViewModel
    }

    // MARK: - Views

    var body: some View {
        VStack(alignment: .leading, spacing: 22.0) {
            SelectCityHeaderView(
                viewModel: .init(),
                mainHeaderViewModel: mainHeaderViewModel,
                isChangeMode: $isChangeMode
            )
            Text("Выберете место")
                .font(.system(size: 24, weight: .heavy))
                .multilineTextAlignment(.leading)
                .foregroundColor(.lightText | .white)
            Text("Отслеживайте погоду в родном городе и, отправляясь в путешевствие")
                .foregroundColor(.lightText | .darkWhite)
            searchButton
            citiesListView
        }
        .padding()
        .background(Color.lightBackground | Color.darkBackground2)
        .onAppear { viewModel.loadData() }
        .onTapGesture { UIApplication.shared.endEditing() }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $viewModel.showingPopup, autohideIn: 2) {
            ZStack(alignment: .center) {
                Color.lightBackground | Color.darkBackground
                Text("Добавлен новый город \nВыберете его, чтобы сделать главным.")
                    .foregroundColor(.black | .white)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            }.frame(height: 112)
        }
    }

    var searchButton: some View {
        Button(action: {
            self.presentingModal.toggle()
        }) {
            searchView
        }.sheet(isPresented: $presentingModal) {
            SearchListView(viewModel: viewModel.searchListViewModel, presentingModal: $presentingModal)
        }.allowsHitTesting(!isChangeMode)
    }

    var searchView: some View {
        HStack {
            Image("search", bundle: nil)
                .opacity(isChangeMode ? 0.5 : 1)
            Text("Поиск")
                .foregroundColor(.lightText2)
                .font(.headline)
                .opacity(isChangeMode ? 0.5 : 1)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.lightBackground2 | Color.darkBackground)
                .frame(height: 40)
        )
    }

    private var columns: [GridItem] = [
        GridItem(.fixed(156), spacing: 16),
        GridItem(.fixed(156), spacing: 16)
    ]

    var citiesListView: some View {
        ScrollView {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 16.0,
                      pinnedViews: .sectionHeaders) {
                ForEach(viewModel.weathers, id: \.self) { model in
                    CityCardView(
                        model: model,
                        isChangeMode: $isChangeMode,
                        viewModel: viewModel.cityCardViewModel
                    )
                        .shadow(color: .lightBackground2 | .darkBackground2, radius: 10, x: 0, y: 0)
                        .onTapGesture {
                            guard !isChangeMode else { return }
                            viewModel.selectCity(with: model)
                        }
                    
                }
            }.padding(.top, 18.0)
        }
    }

}

struct AddSitiesView_Previews: PreviewProvider {

    static var previews: some View {
        SelectCityView(viewModel: .init(
            weatherService: ServicesAssemblyFactory().weatherNetworkService,
            locationService: ServicesAssemblyFactory().locationNetworkService), mainHeaderViewModel: .init())
    }

}
