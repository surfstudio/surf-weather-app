//
//  MainCorouselView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct MainCorouselView: View {

    // MARK: - Properties

    var viewModel: MainCorouselViewModel

    // MARK: - Body

    var body: some View {
        ScalePageView(viewModel.items) { item in
            CardView(model: item)
        }
        .pagePadding(left: .absolute(30), right: .absolute(30))
        .frame(height: 360)
    }

}

// MARK: - Preview

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        MainCorouselView(viewModel: .init())
    }
}
