//
//  MainScreenCarouselView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 05.03.2022.
//

import SwiftUI

struct MainScreenCarouselView: View {

    // MARK: - Properties

    var count = 5
    @State var currentIndex: Int = 0
    @GestureState var offset: CGFloat = 0

    // MARK: - Views

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width

            HStack(spacing: 16) {
                ForEach(0..<5) { _ in
                    ZStack {
                        Rectangle()
                            .frame(width: width - 16,
                                   height: 320,
                                   alignment: .center)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 16)
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onChanged { value in
//                        let offsetX = value.translation.width
//                        let progress = -offsetX / width
//                        let roundedIndex = progress.rounded()
//                        currentIndex = max(min(currentIndex + Int(roundedIndex), count - 1), 0)
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

}

struct MainScreenCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenCarouselView()
    }
}
