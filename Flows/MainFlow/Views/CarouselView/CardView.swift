//
//  CardView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct CardView: View {

    struct Model: Identifiable {
        let id: Int
        let dayly: String
        var temperature: String
        let sky: String
        var hourly: [HourlyCardView.Model]
    }

    @ObservedObject var viewModel: CardViewModel
    @Binding var page: CGFloat
    let itemSize: CGSize
    @State var hourProgres: CGFloat = 0
    @State var isNeedUpdateHour = false

    var body: some View {
        ZStack {
            Image(UserDefaultsService.shared.isLightMode ? "card_background_light" : "card_background_dark", bundle: nil)
                .resizable(capInsets: .init(top: 20, leading: 0, bottom: 20, trailing: 0), resizingMode: .stretch)
            VStack {
                HStack(alignment: .top) {
                    makeTempBigView().padding(.top, 20).padding(.leading, 24)
                    Spacer()
                    Image("sun_big", bundle: nil)
                }
                Spacer()
                Image("separator", bundle: nil)
                Spacer()
                hourlyWeatherListView
                Spacer()
            }
        }
        .frame(width: itemSize.width, height: itemSize.height, alignment: .center)
        .cornerRadius(32)
        .scaleEffect(makeScale())
    }

    func makeScale() -> CGSize {
        let maxScale = 1.0
        let maxReductionPercent = 0.3 // Максимальный процент уменьшения крайних вьюх где 0.3 - это уменьшить на 30 %
        let scaleProgress = abs(page - CGFloat(viewModel.model.id)) * maxReductionPercent
        let scale = maxScale - scaleProgress
        
        return .init(width: maxScale, height: scale)
    }

    var hourlyWeatherListView: some View {
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
            ScrollIndicatorView(progres: $hourProgres, visibleItemCount: visibleItemCounts)
        }
    }

    func makeTempBigView() -> some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(viewModel.model.dayly)
                .foregroundColor(.white.opacity(0.64))
                .font(Font(.init(.system, size: 12)))
            HStack(alignment: .top, spacing: 8) {
                Text(viewModel.model.temperature)
                    .foregroundColor(.white)
                    .font(Font(.init(.system, size: 72)))
                Text("&deg;")
                    .foregroundColor(.white.opacity(0.64))
                    .font(Font(.init(.system, size: 72)))
                    .padding(.top, -3)
            }
            Text(viewModel.model.sky)
                .foregroundColor(.white)
                .font(Font(.init(.system, size: 24)))
        }
    }

}
