//
//  BottomSheetView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import SwiftUI

fileprivate enum BottomSheetConstants {
    static let radius = 20.0
    static let snapRatio = 0.5
    static let titleFont: Font = .system(size: 16)
    static let closeButtonSize = 24.0
}

fileprivate enum SuperViewSettings {
    static let darkBrightnes = -0.3
    static let blurRadius = 10.0
}

struct BottomSheetModifier<BottomSheetContent: View>: ViewModifier {

    // MARK: - Properties

    @Binding var isOpen: Bool

    let title: String
    let maxHeight: CGFloat
    let content: BottomSheetContent

    // MARK: - Private Properties

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? .zero : maxHeight
    }

    // MARK: - Initialization

    init(
        isOpen: Binding<Bool>,
        title: String,
        height: CGFloat,
        @ViewBuilder content: () -> BottomSheetContent
    ) {
        self.title = title
        self.maxHeight = height
        self.content = content()
        self._isOpen = isOpen
    }

    // MARK: - View

    func body(content: Content) -> some View {
        ZStack {
            content
                .brightness(isOpen ? SuperViewSettings.darkBrightnes : .zero)
                .blur(radius: isOpen ? SuperViewSettings.blurRadius : .zero)
                .allowsHitTesting(!isOpen)
            bottomSheetView
                .edgesIgnoringSafeArea(.all)
        }
    }

    var bottomSheetView: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                topView.padding([.leading, .trailing, .top])
                content
            }
            .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
            .background(.white | .darkBackground2)
            .cornerRadius(BottomSheetConstants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(offset + translation, .zero))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = maxHeight * BottomSheetConstants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    isOpen = value.translation.height < .zero
                }
            )
        }
    }

    var topView: some View {
        HStack {
            Rectangle().foregroundColor(.clear)
                .frame(width: BottomSheetConstants.closeButtonSize, height: BottomSheetConstants.closeButtonSize)
            Spacer()
            Text(title).font(BottomSheetConstants.titleFont)
            Spacer()
            Button { isOpen = false } label: {
                Image("closeButton", bundle: nil)
            }.frame(width: BottomSheetConstants.closeButtonSize, height: BottomSheetConstants.closeButtonSize)
        }
    }

}

extension View {

    func bottomSheet<BottomSheetContent: View>(
        isOpen: Binding<Bool>,
        title: String,
        height: CGFloat,
        @ViewBuilder content: () -> BottomSheetContent
    ) -> some View {
        self.modifier(BottomSheetModifier(isOpen: isOpen, title: title, height: height, content: content))
    }

}
