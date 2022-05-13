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
                mainHeaderViewModel: mainHeaderViewModel
            )
            Text("Выберете место")
                .font(.system(size: 24, weight: .heavy))
                .multilineTextAlignment(.leading)
                .foregroundColor(.lightText | .white)
            Text("Отслеживайте погоду в родном городе и, отправляясь в путешевствие")
                .foregroundColor(.lightText | .darkWhite)
            SearchBarView(searchText: $viewModel.searchText)
            citiesListView
        }
        .padding()
        .background(Color.lightBackground | Color.darkBackground2)
        .onAppear { viewModel.loadData() }
        .onTapGesture { UIApplication.shared.endEditing() }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
                    CityCardView(model: model)
                        .shadow(color: .lightBackground2 | .darkBackground2, radius: 10, x: 0, y: 0)
                        .onTapGesture {
                            selectCity(with: model)
                            UIApplication.shared.endEditing()
                        }
                    
                }
            }.padding(.top, 18.0)
        }
    }

    // MARK: - Methods

    func selectCity(with model: CityCardView.Model) {
        for (index, _) in viewModel.weathers.enumerated() {
            viewModel.weathers[index].isSelected = false
        }
        guard let index = viewModel.weathers.firstIndex(where: { $0.id == model.id }) else {
            return
        }
        UserDefaultsService.shared.selectedCity = viewModel.weathers[index].city
        viewModel.weathers[index].isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                let selectedModel = viewModel.weathers.remove(at: index)
                viewModel.weathers.insert(selectedModel, at: 0)
            }
        }
    }

}

struct AddSitiesView_Previews: PreviewProvider {

    static var previews: some View {
        SelectCityView(viewModel: .init(weatherService: ServicesAssemblyFactory().weatherNetworkService), mainHeaderViewModel: .init())
    }

}
