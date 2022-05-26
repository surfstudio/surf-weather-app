
import Foundation
import UIKit

public struct ScaleTransformViewOptions {
    
    // MARK: Properties
    
    /// Минимальный коэффициент масштабирования для боковых вью
    public var minScale: CGFloat
    
    /// Максимальный коэффициент масштабирования для боковых вью
    public var maxScale: CGFloat
    
    /// Соотношение для расчета масштаба для каждого элемента
    /// Scale = 1 - progress * `scaleRatio`
    public var scaleRatio: CGFloat
    
    /// Соотношение количества переводов для боковых вью, рассчитывается по размеру `scalableView`
    /// например, если translationRatio.x = 0,5 и scalableView.width = 100, то
    /// translateX = 50 для вью справа и translateX = -50 для вью слева
    public var translationRatio: CGPoint
    
    /// Минимальный объем перевода для боковых вью рассчитывается как `translationRatio`
    public var minTranslationRatio: CGPoint?
    
    /// Максимальный объем перевода для боковых вью, рассчитывается как `translationRatio`
    public var maxTranslationRatio: CGPoint?
    
    /// Поскольку он применяет масштаб к представлениям, расстояние между представлениями не будет равным
    /// по умолчанию, если этот флаг включен, расстояние между элементами будет одинаковым
    public var keepVerticalSpacingEqual: Bool
    
    /// Подобно `keepHorizontalSpacingEqual`, но для горизонтального интервала
    public var keepHorizontalSpacingEqual: Bool

    // MARK: Lifecycle

    public init(
        minScale: CGFloat = 0.9,
        maxScale: CGFloat = 1,
        scaleRatio: CGFloat = 0.7,
        translationRatio: CGPoint = .init(x: 0.93, y: 0.36),
        minTranslationRatio: CGPoint? = .init(x: -5, y: -5),
        maxTranslationRatio: CGPoint? = .init(x: 5, y: 5),
        keepVerticalSpacingEqual: Bool = true,
        keepHorizontalSpacingEqual: Bool = true
    ) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.scaleRatio = scaleRatio
        self.translationRatio = translationRatio
        self.minTranslationRatio = minTranslationRatio
        self.maxTranslationRatio = maxTranslationRatio
        self.keepVerticalSpacingEqual = keepVerticalSpacingEqual
        self.keepHorizontalSpacingEqual = keepHorizontalSpacingEqual
    }

    static func layout() -> Self {
        return Self(
            minScale: 0.6,
            scaleRatio: 0.4,
            translationRatio: CGPoint(x: 0.66, y: 0.2),
            maxTranslationRatio: CGPoint(x: 2, y: 0),
            keepVerticalSpacingEqual: true,
            keepHorizontalSpacingEqual: true
        )
    }

}
