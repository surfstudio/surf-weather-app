//
//  CustomScrollView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.06.2022.
//

import UIKit
import SwiftUI

struct CustomScrollView<Stack: View>: UIViewRepresentable, ParentScrollable {

    // MARK: - Properties

    var size: CGSize
    var itemCount: Int
    var view: Stack
    @Binding var page: CGFloat
    @Binding var isNeedUpdate: Bool

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()

        configureScrollView(context: context, scrollView: scrollView)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        guard isNeedUpdate else { return }
        uiView.subviews.forEach { $0.removeFromSuperview() }
        configureScrollView(context: context, scrollView: uiView)
    }

    func makeCoordinator() -> CustomScrollCoordinator {
        return CustomScrollCoordinator(parent: self, itemWidth: size.width)
    }
    
}

// MARK: - Private

 extension CustomScrollView {

     func configureScrollView(context: Context, scrollView: UIScrollView) {
         let total = size.width * CGFloat(itemCount)

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
         let view = view.onAppear {
             isNeedUpdate = false
         }
         let contentView = UIHostingController(rootView: view)
         contentView.view.frame = CGRect(x: .zero, y: .zero, width: contentWidth, height: size.height)
         contentView.view.backgroundColor = .clear

         return contentView.view
     }
    
}
