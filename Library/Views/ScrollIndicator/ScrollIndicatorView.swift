//
//  ScrollIndicatorView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.06.2022.
//

import SwiftUI

struct ScrollIndicatorView: View {

    // MARK: - Constants

    private enum Constants {
        static let pageWidth: CGFloat = 24
        static let height: CGFloat = 4
        static let radius: CGFloat = 4
    }

    // MARK: - Properties

    @Binding var progres: CGFloat
    var visibleItemCount: CGFloat
    var itemCount: CGFloat

    // MARK: - View

    var body: some View {
        ZStack(alignment: .leading) {
            let pagesCount = itemCount / visibleItemCount
            Rectangle()
                .foregroundColor(.white.opacity(0.24))
                .frame(width: pagesCount * Constants.pageWidth, height: Constants.height)
                .cornerRadius(Constants.radius)
            Rectangle()
                .foregroundColor(.white)
                .frame(width: Constants.pageWidth, height: Constants.height)
                .cornerRadius(Constants.radius)
                .padding(.leading, getPadding())
        }
    }

    // MARK: - Private Methods

    private func getPadding() -> CGFloat {
        let pageProgres = progres / visibleItemCount
        return pageProgres * Constants.pageWidth
    }

}

