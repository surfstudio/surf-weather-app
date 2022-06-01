//
//  CarouselView.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.05.2022.
//

import UIKit
import SwiftUI

struct CarouselView: UIViewRepresentable {

    // MARK: - Constants

    private enum Constants {
        static let itemSpacing: CGFloat = 16
        static let itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 360)
    }

    // MARK: - Properties

    @State var page: CGFloat = 0
    let viewModel: CarouselViewModel
    let scrollView = UIScrollView()

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIScrollView {
        configureScrollView(context: context)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
    }

    func makeCoordinator() -> ScrollDelegate {
        return ScrollDelegate(parent: self, itemWidth: Constants.itemSize.width, itemSpacing: Constants.itemSpacing)
    }
    
}

// MARK: - Private

 extension CarouselView {

    func configureScrollView(context: Context) {
        let leftAndRightInsets = UIScreen.main.bounds.width - Constants.itemSize.width
        let total = (Constants.itemSize.width + Constants.itemSpacing) *
            CGFloat(viewModel.cardViewModels.count) - Constants.itemSpacing + leftAndRightInsets

        scrollView.contentSize = CGSize(width: total, height: 1.0)
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.delegate = context.coordinator

        let subview = makeContentView(with: total)
        scrollView.addSubview(subview)
    }

     func makeContentView(with contentWidth: CGFloat) -> UIView {
         let contentView = UIHostingController(rootView: pagerView)
         contentView.view.frame = CGRect(x: .zero, y: .zero, width: contentWidth, height: Constants.itemSize.height)
         contentView.view.backgroundColor = .clear

         return contentView.view
     }

     var pagerView: some View {
         HStack(alignment: .center, spacing: Constants.itemSpacing) {
             ForEach(viewModel.cardViewModels) { cardViewModel in
                 CardView(viewModel: cardViewModel, page: $page, itemSize: Constants.itemSize)
             }
         }
     }
    
}
