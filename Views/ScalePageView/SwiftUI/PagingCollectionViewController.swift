
import UIKit
import SwiftUI

typealias PaddingCollectionDelegates = UICollectionViewDataSource &
CollectionViewPagingLayoutDelegate &
UICollectionViewDelegate &
UIScrollViewDelegate

public class PagingCollectionViewController<ValueType: Identifiable, PageContent: View>: UIViewController, PaddingCollectionDelegates {

    // MARK: Properties

    var modifierData: PagingCollectionViewModifierData?
    var pageViewBuilder: ((ValueType, CGFloat) -> PageContent)!
    var onCurrentPageChanged: ((Int) -> Void)?

    private var collectionView: UICollectionView!
    private var list: [ValueType] = []
    private let layout = CollectionViewPagingLayout()

    // MARK: UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupCollectionView()
    }


    // MARK: Public functions

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PagingCollectionViewCell<ValueType, PageContent> = collectionView.dequeueReusableCellClass(for: indexPath)
        cell.update(value: list[indexPath.row], index: indexPath, parent: self)
        return cell
    }

    public func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {
        onCurrentPageChanged?(currentPage)
    }


    // MARK: Internal functions

    func update(list: [ValueType], currentIndex: Int?) {
        var needsUpdate = false
        
        if let self = self as? PagingCollectionViewControllerEquatableList {
            needsUpdate = !self.isListSame(as: list)
        } else {
            let oldIds = self.list.map(\.id)
            needsUpdate = list.map(\.id) != oldIds
        }
        self.list = list
        if needsUpdate {
            collectionView?.reloadData()
            layout.invalidateLayoutInBatchUpdate(invalidateOffset: true)
        }
    }

    // MARK: UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modifierData?.onTapPage?(indexPath.row)
    }

    // MARK: Private functions
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: view.frame,
            collectionViewLayout: layout
        )
        layout.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.registerClass(PagingCollectionViewCell<ValueType, PageContent>.self)
        collectionView.dataSource = self
        view.fill(with: collectionView)
        layout.numberOfVisibleItems = modifierData?.numberOfVisibleItems
        layout.scrollDirection = modifierData?.scrollDirection ?? layout.scrollDirection
        layout.transparentAttributeWhenCellNotLoaded = modifierData?.transparentAttributeWhenCellNotLoaded ?? layout.transparentAttributeWhenCellNotLoaded
        collectionView.delegate = self

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        modifierData?.collectionViewProperties.forEach { property in
            if let keyPath: WritableKeyPath<UICollectionView, Bool> = property.getKey(),
               let value: Bool = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, UIView> = property.getKey(),
               let value: UIView = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, UIColor> = property.getKey(),
               let value: UIColor = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, UIScrollView.ContentInsetAdjustmentBehavior> = property.getKey(),
               let value: UIScrollView.ContentInsetAdjustmentBehavior = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, UIEdgeInsets> = property.getKey(),
               let value: UIEdgeInsets = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, CGFloat> = property.getKey(),
               let value: CGFloat = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
            if let keyPath: WritableKeyPath<UICollectionView, CGSize> = property.getKey(),
               let value: CGSize = property.getValue() {
                collectionView[keyPath: keyPath] = value
            }
        }
    }


}

private protocol PagingCollectionViewControllerEquatableList {
    func isListSame<T>(as list: [T]) -> Bool
}

extension PagingCollectionViewController: PagingCollectionViewControllerEquatableList where ValueType: Equatable {
    func isListSame<T>(as list: [T]) -> Bool {
        self.list == (list as? [ValueType])
    }
}

private extension UICollectionView {
    func registerClass<T: UICollectionViewCell>(_ cellType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCellClass<T: UICollectionViewCell>(for indexPath: IndexPath, type: T.Type? = nil, reuseIdentifier: String = T.reuseIdentifier) -> T {
        (dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T)!
    }
}


private extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
