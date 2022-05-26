
import Foundation
import UIKit

public protocol TransformableView {
    
    /// Представление для обнаружения жестов
    ///
    /// Если вы хотите обработать это вручную, верните `nil`
    var selectableView: UIView? { get }

    /// Отправляет значение с плавающей запятой в зависимости от положения представления (ячейки)
    /// если представление находится в центре CollectionView, оно отправляет 0
    /// значение может быть отрицательным или положительным и представляет собой расстояние до центра вашего CollectionView.
    /// например `1` означает расстояние между центром ячейки и центром вашего CollectionView
    /// равно вашей ширине CollectionView.
    ///
    /// - Parameter progress: интерполированный прогресс для представления ячейки
    func transform(progress: CGFloat)
    
    /// Необязательная функция для предоставления Z-индекса (позиции) представления ячейки
    /// Как определено как расширение, значение zIndex по умолчанию равно Int(-abs(round(progress)))
    ///
    /// - Parameter progress: интерполированный прогресс для представления ячейки
    /// - Returns: индекс z (позиция)
    func zPosition(progress: CGFloat) -> Int
}


public extension TransformableView {
    
    /// Определение значения zIndex по умолчанию
    func zPosition(progress: CGFloat) -> Int {
        Int(-abs(round(progress)))
    }
}


public extension TransformableView where Self: UICollectionViewCell {
    
    /// По умолчанию `selectableView` для `UICollectionViewCell` является первым подпредставлением
    /// `contentView` или само view содержимого, если нет subview
    var selectableView: UIView? {
        contentView.subviews.first ?? contentView
    }
}
