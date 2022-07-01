//
//  ShimmerView.swift
//  SurfWeatherApp
//
//  Created by porohov on 12.04.2022.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    
    // MARK: - Properties
    
    let isActive: Bool
    
    // MARK: - View Modifier
    
    @ViewBuilder func body(content: Content) -> some View {
        if isActive {
            content.overlay(ShimmerView().clipped())
        } else {
            content
        }
    }
}

struct ShimmerView : View {
    
    // MARK: - States
    
    @EnvironmentObject var shimmerConfig: ShimmerConfig
    
    // MARK: - Properties
    
    var linearGradient: LinearGradient {
        let startGradient = Gradient.Stop(color: shimmerConfig.bgColor, location: 0.3)
        let endGradient = Gradient.Stop(color: shimmerConfig.bgColor, location: 0.7)
        let maskGradient = Gradient.Stop(color: shimmerConfig.shimmerColor, location: 0.5)
        let gradient = Gradient(stops: [startGradient, maskGradient, endGradient])
        return LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
    }

    // MARK: - View
    
    var body: some View {
        GeometryReader {
            content(shimmerOffset: $0.size.width + CGFloat(2 * shimmerConfig.shimmerAngle))
        }
    }
    
    // MARK: - View methods
    
    func content(shimmerOffset: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
            
            Rectangle()
                .foregroundColor(.clear)
                .background(linearGradient)
                .rotationEffect(Angle(degrees: shimmerConfig.shimmerAngle))
                .offset(x: (shimmerConfig.isActive ? 1 : -1) * shimmerOffset, y: .zero)
                .transition(.move(edge: .leading))
                .animation(.linear(duration: shimmerConfig.shimmerDuration), value: Double.zero)
        }
        .padding(.vertical(-shimmerOffset))
    }
}

public extension EdgeInsets {

    static func vertical(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: .zero, bottom: value, trailing: .zero)
    }

}

extension View {

    public func shimmer(isActive: Bool) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}


import SwiftUI
import Combine

public class ShimmerConfig: ObservableObject {
    
    // MARK: - States
    
    @Published var isActive: Bool = false
    
    // MARK: - Properties
    
    let bgColor: Color
    let fgColor: Color
    let shimmerColor: Color
    let shimmerAngle: Double
    let shimmerDuration: TimeInterval
    let shimmerDelay: TimeInterval

    // MARK: - Private Properties
    
    private var timer: AnyCancellable?
    
    // MARK: - Initialization and deinitialization

    public init(bgColor: Color = Color(white: 0.8),
                fgColor: Color = .white,
                shimmerColor: Color = Color(white: 0.8, opacity: 0.2),
                shimmerAngle: Double = 1,
                shimmerDuration: TimeInterval = 1,
                shimmerDelay: TimeInterval = 2) {
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.shimmerColor = shimmerColor
        self.shimmerAngle = shimmerAngle
        self.shimmerDuration = shimmerDuration
        self.shimmerDelay = shimmerDelay
    }
    
    deinit {
        stopAnimation()
    }
    
    // MARK: - Public methods
    
    public func startAnimation() {
        stopAnimation()
        timer?.cancel()
        timer = Timer
            .publish(every: shimmerDelay, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.isActive = false
                withAnimation { self.isActive = true }
            })
    }
    
    public func stopAnimation() {
        timer?.cancel()
        timer = nil
        isActive = false
    }
}

