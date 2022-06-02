//
//  ScrollDelegate.swift
//  SurfWeatherApp
//
//  Created by porohov on 30.05.2022.
//

import UIKit

final class ScrollDelegate: NSObject, UIScrollViewDelegate {

    // MARK: - Properties

    let parent: CarouselView
    let itemWidth: CGFloat
    let itemSpacing: CGFloat

    // MARK: - Initialization

    init(parent: CarouselView, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.parent = parent
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = itemWidth + itemSpacing
        let page = scrollView.contentOffset.x / width

        self.parent.page = page
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let width = itemWidth + itemSpacing
        let page = trunc(scrollView.contentOffset.x / width)

        if (parent.page - page) > 0.5 {
            targetContentOffset.pointee.x = width * (page + 1)
        } else {
            targetContentOffset.pointee.x = width * page
        }
    }

}
