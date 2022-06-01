//
//  CustomScrollCoordinator.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.06.2022.
//

import Foundation
import UIKit

protocol ParentScrollable {
    var page: CGFloat { get set }
}

class CustomScrollCoordinator: NSObject, UIScrollViewDelegate {

    var parent: ParentScrollable
    let itemWidth: CGFloat

    init(parent: ParentScrollable, itemWidth: CGFloat) {
        self.parent = parent
        self.itemWidth = itemWidth
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / itemWidth

        parent.page = page
    }

}
