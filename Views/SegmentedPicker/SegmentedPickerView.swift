//
//  SegmentedPickerView.swift
//  SurfWeatherApp
//
//  Created by Владислав Климов on 25.02.2022.
//

import SwiftUI

struct SegmentedPickerView: View {

    // MARK: - Constants

    private enum Constants {
        static let height: CGFloat = 36
    }

    // MARK: - States

    @Binding var selected: Int
    @State var position: CGFloat = 0

    // MARK: - Properties

    var elements: [String]

    // MARK: - Views

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.backgroundColor)


                RoundedRectangle(cornerRadius: 9)
                    .foregroundColor(.itemColor)
                    .frame(width: proxy.size.width / CGFloat(elements.count) - 4,
                           height: 32,
                           alignment: .leading)
                    .position(x: position, y: 18)

                HStack(spacing: 0) {
                    ForEach(0..<elements.count, id: \.self) { item in
                        Button(action: {
                            selected = item
                        }) {
                            Text(elements[item])
                                .font(.system(size: 14))
                                .foregroundColor(selected == item ? .activeTextColor : .inactiveTextColor)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: Constants.height, alignment: .center)
            .onChange(of: selected) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    position = calculatePosition(for: proxy.size.width)
                }
            }
            .onAppear {
                position = calculatePosition(for: proxy.size.width)
            }
        }
        .frame(height: Constants.height)
    }

    // MARK: - Private Methods

    private func calculatePosition(for width: CGFloat) -> CGFloat {
        let itemWidth = width / CGFloat(elements.count)
        return (itemWidth / 2) + itemWidth * CGFloat(selected)
    }

}

fileprivate extension Color {

    static var backgroundColor: Color {
        .lightBackground2 | .darkBackground
    }

    static var itemColor: Color {
        .lightBackground | .darkBackground2
    }

    static var activeTextColor: Color {
        .lightText | .darkWhite
    }

    static var inactiveTextColor: Color {
        .lightText2 | .darkText2
    }

}

struct SegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(selected: .constant(1), elements: ["SomeCase", "AnotherCase", "LastCase"])
    }
}
