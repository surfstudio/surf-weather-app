
import Foundation

public extension CollectionViewPagingLayout {
    enum ZPositionHandler {
        /// Sets cell.layer.zPosition
        case cellLayer

        /// Sets UICollectionViewLayoutAttributes.zIndex
        case layoutAttribute

        /// Sets both of `cellLayer` and `layoutAttribute`
        case both
    }
}
