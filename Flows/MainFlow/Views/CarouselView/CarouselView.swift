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
        static let maxReductionPercent: CGFloat = 0.3 // Максимальный процент уменьшения крайних вьюх где 0.3 - это уменьшить на 30 %
        static let longItemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 360)
        static let shortItemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 188)
    }

    // MARK: - Properties

    @State var page: CGFloat = 0
    @Binding var cardMode: CardView.Mode
    @Binding var updateIsNeeded: Bool
    @ObservedObject var viewModel: CarouselViewModel

    // MARK: - Private Properties

    private var itemSpacingWithScale: CGFloat {
        Constants.itemSpacing - (Constants.longItemSize.width * Constants.maxReductionPercent) / 2
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        configureScrollView(context: context, scrollView: scrollView)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        guard updateIsNeeded else { return }
        uiView.subviews.forEach { $0.removeFromSuperview() }
        configureScrollView(context: context, scrollView: uiView)
    }

    func makeCoordinator() -> ScrollDelegate {
        return ScrollDelegate(parent: self, itemWidth: Constants.longItemSize.width, itemSpacing: itemSpacingWithScale)
    }
    
}

// MARK: - Private

 private extension CarouselView {

     func configureScrollView(context: Context, scrollView: UIScrollView) {
        let leftAndRightInsets = UIScreen.main.bounds.width - Constants.longItemSize.width
        let total = (Constants.longItemSize.width + itemSpacingWithScale) *
            CGFloat(viewModel.cardViewModels.count) - itemSpacingWithScale + leftAndRightInsets

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
         let height = cardMode == .short ? Constants.shortItemSize.height : Constants.longItemSize.height
         contentView.view.frame = CGRect(x: .zero, y: .zero, width: contentWidth, height: height)
         contentView.view.backgroundColor = .clear

         return contentView.view
     }

     var pagerView: some View {
         let itemSize = cardMode == .short ? Constants.shortItemSize : Constants.longItemSize
    
         return HStack(alignment: .center, spacing: itemSpacingWithScale) {
             ForEach(viewModel.cardViewModels.indices) {
                 let model = viewModel.cardViewModels[$0]
                 let percent = Constants.maxReductionPercent
                 CardView(viewModel: model, mode: $cardMode, page: $page, cardId: $0, itemSize: itemSize, maxReductionPercent: percent)
             }
         }.onAppear { updateIsNeeded = false }
     }
    
}
