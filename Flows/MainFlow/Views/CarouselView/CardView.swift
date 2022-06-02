//
//  CardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct CardView: View {

    // MARK: - Nested

    struct Model {
        let dayly: String
        var temperature: String
        var image: Assets
        var hourly: [HourlyCardView.Model]
    }

    enum Mode {
        case long, short
    }

    // MARK: - Properties

    @ObservedObject var viewModel: CardViewModel
    @Binding var mode: Mode
    @Binding var page: CGFloat
    let cardId: Int
    let itemSize: CGSize

    // MARK: - Private  Properties

    @State private var hourProgres: CGFloat = 0
    @State private var isNeedUpdateHour = false
    @ObservedObject private var storage = UserDefaultsService.shared

    // MARK: - Views

    var body: some View {
        ZStack {
            Image(storage.isLightMode ? "big_background_light" : "big_background_dark", bundle: nil)
                .resizable(capInsets: .init(top: 20, leading: 0, bottom: 20, trailing: 0), resizingMode: .stretch)
            VStack {
                topView
                switch mode {
                case .long:
                    Spacer()
                    separatorView
                    Spacer()
                    bottomView
                    Spacer()
                case .short:
                    Spacer()
                }
            }
        }
        .frame(width: itemSize.width, height: itemSize.height, alignment: .center)
        .cornerRadius(32)
        .scaleEffect(makeScale())
    }

    var topView: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.model.dayly)
                        .foregroundColor(.opacityWhite)
                        .font(Font(.init(.system, size: 12)))
                    HStack(alignment: .top, spacing: 8) {
                        Text(viewModel.model.temperature)
                            .foregroundColor(.white)
                            .font(Font(.init(.system, size: 72)))
                        Text("&deg;")
                            .foregroundColor(.opacityWhite)
                            .font(Font(.init(.system, size: 72)))
                            .padding(.top, -3)
                    }
                }
                Spacer()
                Image(viewModel.model.image.imageName, bundle: nil).padding(.top, -70).padding(.trailing, -50)
            }
            Text(viewModel.model.image.description)
                .foregroundColor(.white)
                .font(Font(.init(.system, size: 24)))
        }
        .padding(.top, 20).padding(.leading, 24)
    }

    var separatorView: some View {
        Image("separator", bundle: nil)
    }

    var bottomView: some View {
        let itemSize = CGSize(width: 68, height: 112)
        let padding = 20.0
        let itemCount = viewModel.model.hourly.count
        let visibleItemCounts = (self.itemSize.width - padding * 2) / itemSize.width

        let subview = HStack(spacing: .zero) {
            ForEach(viewModel.model.hourly, id: \.self) { model in
                HourlyCardView(model: model, size: itemSize)
                    .onTapGesture {
                        self.viewModel.selectHourlyWeather(with: model)
                        self.isNeedUpdateHour = true
                    }
            }
        }
        return VStack(spacing: 20) {
            CustomScrollView(size: itemSize, itemCount: itemCount, view: subview, page: $hourProgres, isNeedUpdate: $isNeedUpdateHour)
                .padding(.leading, padding).padding(.trailing, padding)
                .frame(height: itemSize.height)
            ScrollIndicatorView(progres: $hourProgres, visibleItemCount: visibleItemCounts, itemCount: CGFloat(itemCount))
        }
    }

}

// MARK: - Private

private extension CardView {

    func makeScale() -> CGSize {
        let maxScale = 1.0
        let maxReductionPercent = 0.3 // Максимальный процент уменьшения крайних вьюх где 0.3 - это уменьшить на 30 %
        let scaleProgress = abs(page - CGFloat(cardId)) * maxReductionPercent
        let scale = maxScale - scaleProgress

        return .init(width: maxScale, height: scale)
    }

}
