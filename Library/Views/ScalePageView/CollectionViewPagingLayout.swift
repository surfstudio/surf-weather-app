
import UIKit

public protocol CollectionViewPagingLayoutDelegate: AnyObject {

    /// Вызывается при изменении текущей страницы
    ///
    /// - Parameter layout: ссылка на класс макета
    /// - Parameter currentPage: новый индекс текущей страницы
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int)
}


public extension CollectionViewPagingLayoutDelegate {
    func onCurrentPageChanged(layout: CollectionViewPagingLayout, currentPage: Int) {}
}

public class CollectionViewPagingLayout: UICollectionViewLayout {
    
    // MARK: Properties

    /// Количество видимых элементов одновременно
    ///
    /// nil = безлимитный
    public var numberOfVisibleItems: Int?

    /// Константы, указывающие направление прокрутки макета.
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal

    /// Подробности смотрите в ZPositionHandler.
    public var zPositionHandler: ZPositionHandler = .both

    /// Установит `alpha` на ноль, когда ячейка еще не загружена представлением коллекции, включение этого предотвращает отображение ячейки перед применением преобразований, но может вызвать мигание при перезагрузке данных.
    public var transparentAttributeWhenCellNotLoaded: Bool = false

    public private(set) var isAnimating: Bool = false
    
    public weak var delegate: CollectionViewPagingLayoutDelegate?
    
    override public var collectionViewContentSize: CGSize {
        getContentSize()
    }

    /// Индекс текущей страницы
    ///
    /// Используйте `setCurrentPage`, чтобы изменить его
    public private(set) var currentPage: Int = 0 {
        didSet {
            delegate?.onCurrentPageChanged(layout: self, currentPage: currentPage)
        }
    }
    
    private var currentScrollOffset: CGFloat {
        let visibleRect = self.visibleRect
        return scrollDirection == .horizontal ? (visibleRect.minX / max(visibleRect.width, 1)) : (visibleRect.minY / max(visibleRect.height, 1))
    }
    
    private var visibleRect: CGRect {
        collectionView.map { CGRect(origin: $0.contentOffset, size: $0.bounds.size) } ?? .zero
    }
    
    private var numberOfItems: Int {
        guard let numberOfSections = collectionView?.numberOfSections, numberOfSections > 0 else {
            return 0
        }
        return (0..<numberOfSections)
        .compactMap { collectionView?.numberOfItems(inSection: $0) }
        .reduce(0, +)
    }

    private var attributesCache: [(page: Int, attributes: UICollectionViewLayoutAttributes)]?
    private var boundsObservation: NSKeyValueObservation?
    private var lastBounds: CGRect?
    private var originalIsUserInteractionEnabled: Bool?
    private var contentOffsetObservation: NSKeyValueObservation?

    // MARK: Public Methods

    /// Вызывает `invalidateLayout`, заключенный в `performBatchUpdates`
    /// - Parameter invalidateOffset: изменить смещение и немедленно вернуть его
    /// это исправляет проблему zIndex: https://stackoverflow.com/questions/12659301/uicollectionview-setlayoutanimated-not-preserving-zindex
    public func invalidateLayoutInBatchUpdate(invalidateOffset: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            if invalidateOffset,
               let collectionView = self?.collectionView,
               self?.isAnimating == false {
                let original = collectionView.contentOffset
                collectionView.contentOffset = .init(x: original.x + 1, y: original.y + 1)
                collectionView.contentOffset = original
            }

            self?.collectionView?.performBatchUpdates({ [weak self] in
                self?.invalidateLayout()
            })
        }
    }
    
    
    // MARK: UICollectionViewLayout
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let currentScrollOffset = self.currentScrollOffset
        let numberOfItems = self.numberOfItems
        let attributesCount = numberOfVisibleItems ?? numberOfItems
        let visibleRangeMid = attributesCount / 2
        let currentPageIndex = Int(round(currentScrollOffset))
        var initialStartIndex = currentPageIndex - visibleRangeMid
        var initialEndIndex = currentPageIndex + visibleRangeMid
        if attributesCount % 2 != 0 {
            if currentPageIndex < visibleRangeMid {
                initialStartIndex -= 1
            } else {
                initialEndIndex += 1
            }
        }
        let startIndexOutOfBounds = max(0, -initialStartIndex)
        let endIndexOutOfBounds = max(0, initialEndIndex - numberOfItems)
        let startIndex = max(0, initialStartIndex - endIndexOutOfBounds)
        let endIndex = min(numberOfItems, initialEndIndex + startIndexOutOfBounds)
        
        var attributesArray: [(page: Int, attributes: UICollectionViewLayoutAttributes)] = []
        var section = 0
        var numberOfItemsInSection = collectionView?.numberOfItems(inSection: section) ?? 0
        var numberOfItemsInPrevSections = 0
        for index in startIndex..<endIndex {
            var item = index - numberOfItemsInPrevSections
            while item >= numberOfItemsInSection {
                numberOfItemsInPrevSections += numberOfItemsInSection
                section += 1
                numberOfItemsInSection = collectionView?.numberOfItems(inSection: section) ?? 0
                item = index - numberOfItemsInPrevSections
            }
            
            let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
            let pageIndex = CGFloat(index)
            let progress = pageIndex - currentScrollOffset
            var zIndex = Int(-abs(round(progress)))
            
            let cell = collectionView?.cellForItem(at: cellAttributes.indexPath)
            
            if let cell = cell as? TransformableView {
                cell.transform(progress: progress)
                zIndex = cell.zPosition(progress: progress)
            }
            
            if cell == nil || cell is TransformableView {
                cellAttributes.frame = visibleRect
                if cell == nil, transparentAttributeWhenCellNotLoaded {
                    cellAttributes.alpha = 0
                }
            } else {
                cellAttributes.frame = CGRect(origin: CGPoint(x: pageIndex * visibleRect.width, y: 0),
                                              size: visibleRect.size)
            }

            // В некоторых случаях attribute.zIndex не работает, так что это обходной путь.
            if let cell = cell, [ZPositionHandler.both, .cellLayer].contains(zPositionHandler) {
                cell.layer.zPosition = CGFloat(zIndex)
            }

            if [ZPositionHandler.both, .layoutAttribute].contains(zPositionHandler) {
                cellAttributes.zIndex = zIndex
            }
            attributesArray.append((page: Int(pageIndex), attributes: cellAttributes))
        }
        attributesCache = attributesArray
        addBoundsObserverIfNeeded()
        return attributesArray.map(\.attributes)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        updateCurrentPageIfNeeded()
    }
    
    
    // MARK: Private functions
    
    private func updateCurrentPageIfNeeded() {
        var currentPage: Int = 0
        if let collectionView = collectionView {
            let contentOffset = collectionView.contentOffset
            let pageSize = scrollDirection == .horizontal ? collectionView.frame.width : collectionView.frame.height
            let offset = scrollDirection == .horizontal ?
                (contentOffset.x + collectionView.contentInset.left) :
                (contentOffset.y + collectionView.contentInset.top)
            if pageSize > 0 {
                currentPage = Int(round(offset / pageSize))
            }
        }
        if currentPage != self.currentPage, !isAnimating {
            self.currentPage = currentPage
        }
    }
    
    private func getContentSize() -> CGSize {
        var safeAreaLeftRight: CGFloat = 0
        var safeAreaTopBottom: CGFloat = 0
        if #available(iOS 11, *) {
            safeAreaLeftRight = (collectionView?.safeAreaInsets.left ?? 0) + (collectionView?.safeAreaInsets.right ?? 0)
            safeAreaTopBottom = (collectionView?.safeAreaInsets.top ?? 0) + (collectionView?.safeAreaInsets.bottom ?? 0)
        }
        if scrollDirection == .horizontal {
            return CGSize(width: CGFloat(numberOfItems) * visibleRect.width, height: visibleRect.height - safeAreaTopBottom)
        } else {
             return CGSize(width: visibleRect.width - safeAreaLeftRight, height: CGFloat(numberOfItems) * visibleRect.height)
        }
    }

}


extension CollectionViewPagingLayout {

    private func addBoundsObserverIfNeeded() {
        guard boundsObservation == nil else { return }
        boundsObservation = collectionView?.observe(\.bounds, options: [.old, .new, .initial, .prior]) { [weak self] collectionView, _ in
            guard collectionView.bounds.size != self?.lastBounds?.size else { return }
            self?.lastBounds = collectionView.bounds
            self?.invalidateLayoutInBatchUpdate(invalidateOffset: true)
        }
    }

}
