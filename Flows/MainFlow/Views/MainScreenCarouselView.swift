//
//  MainScreenCarouselView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 05.03.2022.
//

import SwiftUI

struct MainScreenCarouselView: View {

    // MARK: - Constants

    private enum Constants {
        static let spacing: CGFloat = 16
        static let sideOffset: CGFloat = 8
        static let minScale: CGFloat = 0.8
        static let boundsСoeff: CGFloat = 0.2
    }

    // MARK: - Properties

    var count = 5
    @State var currentIndex: Int = 0
    @GestureState var offset: CGFloat = 0

    // MARK: - Views

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width

            HStack(spacing: Constants.spacing) {
                ForEach(0..<5) { index in
                    ZStack {
                        Rectangle()
                            .frame(width: width - (Constants.spacing + Constants.sideOffset) * 2,
                                   height: 320,
                                   alignment: .center)
                            .foregroundColor(.red)
                    }
                    .scaleEffect(getScale(width: width, index: index, offset: offset),
                                 anchor: getAnchor(index: index, offset: offset))
                }
            }
            .padding(.horizontal, 24)
            .offset(x: getCurrentOffset(for: width, gestureOffset: offset))
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        let offsetX = value.translation.width
                        if currentIndex == 0, offsetX > 0 {
                            out = value.translation.width * Constants.boundsСoeff
                        } else if currentIndex == 4, offsetX < 0 {
                            out = value.translation.width * Constants.boundsСoeff
                        } else {
                            out = value.translation.width
                        }
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundedIndex), count - 1), 0)
                    }
            )
            .animation(.easeInOut, value: offset == 0)
        }
    }

    func getScale(width: CGFloat, index: Int, offset: CGFloat) -> CGFloat {
        let offset = getCurrentOffset(for: width, gestureOffset: offset)
        let targetOffset = CGFloat(index) * -(width - Constants.spacing * 2)
        let half = width / 2
        var scale = Constants.minScale

        if abs(targetOffset - offset) < half - 24 {
            let abs = abs((abs(targetOffset) - abs(offset)) / (half - 24))
            scale += 0.2 * (1 - abs)
        }

        return scale
    }

    func getAnchor(index: Int, offset: CGFloat) -> UnitPoint {
        if index < currentIndex {
            return .trailing
        } else if index > currentIndex {
            return .leading
        }

        if offset > 0 {
            return .leading
        } else {
            return .trailing
        }
    }

    func getCurrentOffset(for width: CGFloat, gestureOffset: CGFloat) -> CGFloat {
        CGFloat(currentIndex) * -(width - Constants.spacing * 2) + gestureOffset
    }

}

struct MainScreenCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenCarouselView()
    }
}
