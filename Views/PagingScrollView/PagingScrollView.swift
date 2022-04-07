//
//  PagingScrollView.swift
//  SurfWeatherApp
//
//  Created by porohov on 07.04.2022.
//

import SwiftUI

struct PagingScrollView: View {

    private enum Constants {
        static let boundaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        static let edgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        static let fraction: CGFloat = 1.0 / 3.0
        static let minScale: CGFloat = 0.7
        static let maxScale: CGFloat = 1.1
    }

    let items: [AnyView]
    
    init<A: View>(activePageIndex: Binding<Int>, itemCount: Int, containerWidth: CGFloat, itemWidth: CGFloat, itemPadding: CGFloat, @ViewBuilder content: () -> A) {
        let views = content()
        self.items = [AnyView(views)]
        
        self._activePageIndex = activePageIndex
        
        self.containerWidth = containerWidth
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.tileRemain = (containerWidth - itemWidth - 2 * itemPadding)/2
        self.itemCount = itemCount
        self.contentWidth = (itemWidth + itemPadding) * CGFloat(self.itemCount)
        
        self.leadingOffset = tileRemain + itemPadding / 2
    }
    
    /// индекс текущей страницы 0..N-1
    @Binding var activePageIndex : Int
    
    /// containerWidth==frameWidth используется для правильного вычисления смещений
    let containerWidth: CGFloat
    
    /// ширина item
    let itemWidth : CGFloat
    
    /// отступы между элементами
    private let itemPadding : CGFloat
    
    /// сколько окружающих предметов все еще видно
    private let tileRemain : CGFloat
    
    /// общая ширина контейнера
    private let contentWidth : CGFloat
    
    /// смещение для прокрутки первого элемента
    private let leadingOffset : CGFloat
    
    /// Количество items; Я не пришел с решением извлечения правильного счета в инициализаторе.
    private let itemCount : Int
    
    /// некоторый демпфирующий фактор для уменьшения живучести
    private let scrollDampingFactor: CGFloat = 0.01
    
    /// текущее смещение всех элементов
    @State var currentScrollOffset: CGFloat = 0
    
    /// drag offset во время drag gesture
    @State private var dragOffset : CGFloat = 0
    
    
    func offsetForPageIndex(_ index: Int)->CGFloat {
        let activePageOffset = CGFloat(index)*(itemWidth+itemPadding)
        
        return self.leadingOffset - activePageOffset
    }
    
    func indexPageForOffset(_ offset : CGFloat) -> Int {
        guard self.itemCount>0 else {
            return 0
        }
        let offset = self.logicalScrollOffset(trueOffset: offset)
        let floatIndex = (offset)/(itemWidth+itemPadding)
        var computedIndex = Int(round(floatIndex))
        computedIndex = max(computedIndex, 0)
        return min(computedIndex, self.itemCount-1)
    }
    
    /// текущее смещение прокрутки применяется к элементам
    func computeCurrentScrollOffset()->CGFloat {
        return self.offsetForPageIndex(self.activePageIndex) + self.dragOffset
    }
    
    /// логическое смещение, начинающееся с 0 для первого элемента - это упрощает вычисление индекса страницы
    func logicalScrollOffset(trueOffset: CGFloat)->CGFloat {
        return (trueOffset-leadingOffset) * -1.0
    }

    func makeTransform(with geometry: GeometryProxy) -> CGAffineTransform {
        let height: CGFloat = 300 / 2
        let distanceFromCenter = abs(geometry.frame(in: .global).midX - currentScrollOffset - contentWidth / 2.0)
        let scale = max(Constants.maxScale - distanceFromCenter / contentWidth, Constants.minScale)

        return CGAffineTransform(translationX: 0, y: height)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: 0, y: -height)
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            HStack(alignment: .center, spacing: self.itemPadding)  {
                /// building items into HStack
                ForEach(0..<self.items.count) { index in
                    self.items[index]
                        .offset(x: self.currentScrollOffset, y: 0)
                        .frame(width: self.itemWidth)
                }
            }
            .onAppear {
                self.currentScrollOffset = self.offsetForPageIndex(self.activePageIndex)
            }
            .frame(width: self.contentWidth)
            .simultaneousGesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .local) // можно изменить на одновременный жест для работы с кнопками
                    .onChanged { value in
                        self.dragOffset = value.translation.width
                        self.currentScrollOffset = self.computeCurrentScrollOffset()
                    }
                    .onEnded { value in
                        // compute nearest index
                        let velocityDiff = (value.predictedEndTranslation.width - self.dragOffset) * self.scrollDampingFactor
                        let newPageIndex = self.indexPageForOffset(self.currentScrollOffset + velocityDiff)
                        self.dragOffset = 0
                        withAnimation(.interpolatingSpring(mass: 0.1, stiffness: 20, damping: 1.5, initialVelocity: 0)) {
                            self.activePageIndex = newPageIndex
                            self.currentScrollOffset = self.computeCurrentScrollOffset()
                        }
                    }
            )
        }
    }
}
