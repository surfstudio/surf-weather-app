//
//  PopupView.swift
//  PopupView
//
//  Created by Alisa Mylnikova on 23/04/2020.
//  Copyright © 2020 Exyte. All rights reserved.
//

import SwiftUI
import Combine

extension View {

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideIn: Double? = nil,
        dragToDismiss: Bool = true,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        backgroundColor: Color = Color.clear,
        dismissCallback: @escaping () -> () = {},
        @ViewBuilder view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup<Int, PopupContent>(
                isPresented: isPresented,
                animation: animation,
                autohideIn: autohideIn,
                dragToDismiss: dragToDismiss,
                closeOnTap: closeOnTap,
                closeOnTapOutside: closeOnTapOutside,
                backgroundColor: backgroundColor,
                dismissCallback: dismissCallback,
                view: view)
        )
    }

    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

    @ViewBuilder
    fileprivate func addTap(if condition: Bool, onTap: @escaping ()->()) -> some View {
        if condition {
            self.simultaneousGesture(
                TapGesture().onEnded {
                    onTap()
                }
            )
        } else {
            self
        }
    }
}

public struct Popup<Item: Equatable, PopupContent: View>: ViewModifier {
    
    init(isPresented: Binding<Bool>,
         animation: Animation,
         autohideIn: Double?,
         dragToDismiss: Bool,
         closeOnTap: Bool,
         closeOnTapOutside: Bool,
         backgroundColor: Color,
         dismissCallback: @escaping () -> (),
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self._item = .constant(nil)
        self.animation = animation
        self.autohideIn = autohideIn
        self.dragToDismiss = dragToDismiss
        self.closeOnTap = closeOnTap
        self.closeOnTapOutside = closeOnTapOutside
        self.backgroundColor = backgroundColor
        self.dismissCallback = dismissCallback
        self.view = view
        self.isPresentedRef = ClassReference(self.$isPresented)
        self.itemRef = ClassReference(self.$item)
    }

    private enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
    }

    // MARK: - Public Properties

    /// Tells if the sheet should be presented or not
    @Binding var isPresented: Bool
    @Binding var item: Item?

    var sheetPresented: Bool {
        item != nil || isPresented
    }

    var animation: Animation

    /// If nil - never hides on its own
    var autohideIn: Double?

    /// Should close on tap - default is `true`
    var closeOnTap: Bool

    /// Should allow dismiss by dragging
    var dragToDismiss: Bool

    /// Should close on tap outside - default is `true`
    var closeOnTapOutside: Bool
    
    /// Background color for outside area - default is `Color.clear`
    var backgroundColor: Color

    /// is called on any close action
    var dismissCallback: () -> ()

    var view: () -> PopupContent

    /// holder for autohiding dispatch work (to be able to cancel it when needed)
    var dispatchWorkHolder = DispatchWorkHolder()

    // MARK: - Private Properties
    
    /// Class reference for capturing a weak reference later in dispatch work holder.
    private var isPresentedRef: ClassReference<Binding<Bool>>?
    private var itemRef: ClassReference<Binding<Item?>>?

    /// The rect and safe area of the hosting controller
    @State private var presenterContentRect: CGRect = .zero
    @State private var presenterSafeArea: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    /// The rect and safe area of popup content
    @State private var sheetContentRect: CGRect = .zero
    @State private var sheetSafeArea: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    /// Drag to dismiss gesture state
    @GestureState private var dragState = DragState.inactive

    /// Last position for drag gesture
    @State private var lastDragPosition: CGFloat = 0
    
    /// Show content for lazy loading
    @State private var showContent: Bool = false
    
    /// Should present the animated part of popup (sliding background)
    @State private var animatedContentIsPresented: Bool = false
    
    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        return presenterContentRect.minY - presenterSafeArea.top - presenterContentRect.midY + sheetContentRect.height/2
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if presenterContentRect.isEmpty {
            return -1000
        }
        return -presenterContentRect.midY - sheetContentRect.height/2 - 5
    }

    /// The current offset, based on the **presented** property
    private var currentOffset: CGFloat {
        return animatedContentIsPresented ? displayedOffset : hiddenOffset
    }

    // MARK: - Content Builders

    public func body(content: Content) -> some View {
        main(content: content)
            .onAppear {
                appearAction(sheetPresented: sheetPresented)
            }
            .valueChanged(value: isPresented) { isPresented in
                appearAction(sheetPresented: isPresented)
            }
            .valueChanged(value: item) { item in
                appearAction(sheetPresented: item != nil)
            }
    }

    private func main(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect, $presenterSafeArea)

            if showContent {
                backgroundColor
            }
        }
        .overlay(
            Group {
                if showContent {
                    sheet()
                }
            }
        )
    }

    /// This is the builder for the sheet content
    func sheet() -> some View {

        // if needed, dispatch autohide and cancel previous one
        if let autohideIn = autohideIn {
            dispatchWorkHolder.work?.cancel()
            
            // Weak reference to avoid the work item capturing the struct,
            // which would create a retain cycle with the work holder itself.
			
            let block = dismissCallback
            dispatchWorkHolder.work = DispatchWorkItem(block: { [weak isPresentedRef, weak itemRef] in
                isPresentedRef?.value.wrappedValue = false
                itemRef?.value.wrappedValue = nil
                block()
            })
            if sheetPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + autohideIn, execute: work)
            }
        }

        let sheet = ZStack {
            self.view()
                .addTap(if: closeOnTap) {
                    dismiss()
                }
                .frameGetter($sheetContentRect, $sheetSafeArea)
                .offset(y: currentOffset)
                .animation(animation, value: currentOffset)
        }

        let drag = DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)

        return sheet
            .applyIf(dragToDismiss) {
                $0.offset(y: dragOffset())
                    .simultaneousGesture(drag)
            }
    }

    func dragOffset() -> CGFloat {
        if dragState.translation.height < 0 {
            return dragState.translation.height
        }
        return lastDragPosition
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let reference = sheetContentRect.height / 3
        if drag.translation.height < -reference {
            lastDragPosition = drag.translation.height
            withAnimation {
                lastDragPosition = 0
            }
            dismiss()
        }
    }
    
    private func appearAction(sheetPresented: Bool) {
        if sheetPresented {
            showContent = true
            DispatchQueue.main.async {
                animatedContentIsPresented = true
            }
        } else {
            animatedContentIsPresented = false
        }
    }
    
    private func dismiss() {
        dispatchWorkHolder.work?.cancel()
        isPresented = false
        item = nil
        dismissCallback()
    }
}

final class DispatchWorkHolder {
    var work: DispatchWorkItem?
}

private final class ClassReference<T> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
}


extension View {

    @ViewBuilder
    fileprivate func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                onChange(value)
            }
        }
    }
}

extension View {
    public func frameGetter(_ frame: Binding<CGRect>, _ safeArea: Binding<EdgeInsets>) -> some View {
        modifier(FrameGetter(frame: frame, safeArea: safeArea))
    }
}

struct FrameGetter: ViewModifier {

    @Binding var frame: CGRect
    @Binding var safeArea: EdgeInsets

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.safeArea = proxy.safeAreaInsets
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}
