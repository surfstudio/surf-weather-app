//
//  PagerView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct PagerView: View {

    // MARK: - Constants

    private enum Constants {
        static let itemPadding: CGFloat = 16
        static let itemWidth: CGFloat = UIScreen.main.bounds.width - 48
    }

    // MARK: - Private Properties

    @State private var activePageIndex: Int = 0
    private var items: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .gray, .brown]

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            makePagingScrollView(geometry: geometry) {
                ForEach(0 ..< items.count) { index in
                    GeometryReader { geometry2 in
                        CardView()
                            .foregroundColor(items[index])
                            .transformEffect(makeTransform(with: geometry2))
                            .onTapGesture {
                                print ("tap on index: \(index) current:\(self.$activePageIndex)")
                            }
                    }
                }
            }
        }.frame(height:360)
    }
}

// MARK: - Private Methods

private extension PagerView {

    func makePagingScrollView<A: View>(geometry: GeometryProxy, content: () -> A) -> some View {
        PagingScrollView(
            activePageIndex: $activePageIndex,
            itemCount: items.count,
            containerWidth: geometry.size.width,
            itemWidth: Constants.itemWidth,
            itemPadding: Constants.itemPadding,
            content: content
        )
    }

    func makeTransform(with geometry: GeometryProxy) -> CGAffineTransform {
        let height = geometry.size.height / 2
        let paddings = UIScreen.main.bounds.width - Constants.itemWidth
        let contentWidth = (Constants.itemWidth + Constants.itemPadding) * CGFloat(items.count) + paddings - Constants.itemPadding

        let centerItem = geometry.frame(in: .global).midX - UIScreen.main.bounds.width / 2
        let scale = max(1 - abs(centerItem) / contentWidth, 0.7)

        return CGAffineTransform(translationX: 0, y: height)
            .scaledBy(x: 1, y: scale)
            .translatedBy(x: 0, y: -height)
    }

}

// MARK: - Preview

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView()
    }
}
