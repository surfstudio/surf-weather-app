
import Foundation
import UIKit

struct PagingCollectionViewModifierData {
    var scaleOptions: ScaleTransformViewOptions?
    var numberOfVisibleItems: Int?
    var zPositionProvider: ((CGFloat) -> Int)?
    var collectionViewProperties: [CollectionViewPropertyProtocol] = []
    var onTapPage: ((Int) -> Void)?
    var scrollDirection: UICollectionView.ScrollDirection?
    var pagePadding: PagePadding?
    var transparentAttributeWhenCellNotLoaded: Bool?
}

protocol CollectionViewPropertyProtocol {
    func getKey<T>() -> WritableKeyPath<UICollectionView, T>?
    func getValue<T>() -> T?
}

struct CollectionViewProperty<T>: CollectionViewPropertyProtocol {
    let keyPath: WritableKeyPath<UICollectionView, T>
    let value: T

    func getKey<T>() -> WritableKeyPath<UICollectionView, T>? {
        keyPath as? WritableKeyPath<UICollectionView, T>
    }

    func getValue<T>() -> T? {
        value as? T
    }
}
