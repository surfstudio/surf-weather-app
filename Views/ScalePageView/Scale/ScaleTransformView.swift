
import UIKit

/// A protocol for adding scale transformation to `TransformableView`
public protocol ScaleTransformView: TransformableView {
    
    /// Варианты управления эффектом масштаба см.`ScaleTransformViewOptions.swift`
    var scaleOptions: ScaleTransformViewOptions { get }
    
    /// view к которому применяется эффект масштаба
    var scalableView: UIView { get }
    
    /// основная функция для применения преобразований
    func applyScaleTransform(progress: CGFloat)
}

public extension ScaleTransformView where Self: UICollectionViewCell {

    /// `scalableView` по умолчанию для `UICollectionViewCell` является первым subview
    /// `contentView` или само content view, если нет подпредставления
    var scalableView: UIView {
        contentView.subviews.first ?? contentView
    }
}


public extension ScaleTransformView {
    
    // MARK: Properties
    
    var scaleOptions: ScaleTransformViewOptions {
        .init()
    }
    
    // MARK: TransformableView
    
    func transform(progress: CGFloat) {
        applyScaleTransform(progress: progress)
    }
    
    // MARK: Public functions
    
    func applyScaleTransform(progress: CGFloat) {
        var transform = CGAffineTransform.identity
        var xAdjustment: CGFloat = 0
        var yAdjustment: CGFloat = 0
        let scaleProgress = abs(progress)
        var scale = 1 - scaleProgress * scaleOptions.scaleRatio
        scale = max(scale, scaleOptions.minScale)
        scale = min(scale, scaleOptions.maxScale)
        
        if scaleOptions.keepHorizontalSpacingEqual {
            xAdjustment = ((1 - scale) * scalableView.bounds.width) / 2
            if progress > 0 {
                xAdjustment *= -1
            }
        }
        
        if scaleOptions.keepVerticalSpacingEqual {
            yAdjustment = ((1 - scale) * scalableView.bounds.height) / 2
        }
        
        let translateProgress = abs(progress)
        var translateX = scalableView.bounds.width * scaleOptions.translationRatio.x * (translateProgress * (progress < 0 ? -1 : 1)) - xAdjustment
        var translateY = scalableView.bounds.height * scaleOptions.translationRatio.y * abs(translateProgress) - yAdjustment
        if let min = scaleOptions.minTranslationRatio {
            translateX = max(translateX, scalableView.bounds.width * min.x)
            translateY = max(translateY, scalableView.bounds.height * min.y)
        }
        if let max = scaleOptions.maxTranslationRatio {
            translateX = min(translateX, scalableView.bounds.width * max.x)
            translateY = min(translateY, scalableView.bounds.height * max.y)
        }
        transform = transform
            .translatedBy(x: translateX, y: translateY)
            .scaledBy(x: scale, y: scale)
        scalableView.transform = transform
    }

}
