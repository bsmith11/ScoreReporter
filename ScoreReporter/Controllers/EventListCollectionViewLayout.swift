//
//  EventListCollectionViewLayout.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class EventListCollectionViewLayout: UICollectionViewLayout {
    private var itemLayoutAttributesCache = [NSIndexPath: UICollectionViewLayoutAttributes]()
    private var headerLayoutAttributesCache = [NSIndexPath: UICollectionViewLayoutAttributes]()

    private var preferredItemLayoutAttributesCache = [NSIndexPath: UICollectionViewLayoutAttributes]()
    private var preferredHeaderLayoutAttributesCache = [NSIndexPath: UICollectionViewLayoutAttributes]()

    private var sectionRects = [Int: CGRect]()

    private var contentHeight = CGFloat(0.0)
    private var contentWidth = CGFloat(0.0)

    var estimatedItemHeight = CGFloat(66.0) {
        didSet {
            invalidateLayout()
        }
    }

    var estimatedHeaderHeight = CGFloat(44.0) {
        didSet {
            invalidateLayout()
        }
    }

    var headerWidth = CGFloat(60.0) {
        didSet {
            invalidateLayout()
        }
    }

    override func prepareLayout() {
        guard let collectionView = collectionView else {
            return
        }

        contentWidth = collectionView.bounds.width

        let x = CGFloat(0.0)
        var y = CGFloat(0.0)

        for section in 0 ..< collectionView.numberOfSections() {
            var indexPath = NSIndexPath(forItem: 0, inSection: section)

            let headerHeight = preferredHeaderLayoutAttributesCache[indexPath]?.size.height ?? estimatedHeaderHeight
            let headerFrame = CGRect(x: x, y: y, width: headerWidth, height: headerHeight)
            let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
            headerLayoutAttributes.frame = headerFrame
            headerLayoutAttributesCache[indexPath] = headerLayoutAttributes

            let sectionOrigin = CGPoint(x: 0.0, y: y)

            for item in 0 ..< collectionView.numberOfItemsInSection(section) {
                indexPath = NSIndexPath(forItem: item, inSection: section)

                let itemHeight = preferredItemLayoutAttributesCache[indexPath]?.size.height ?? estimatedItemHeight
                let itemFrame = CGRect(x: x, y: y, width: contentWidth, height: itemHeight)
                let itemLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemLayoutAttributes.frame = itemFrame

                itemLayoutAttributesCache[indexPath] = itemLayoutAttributes

                y = itemFrame.maxY
            }

            let sectionSize = CGSize(width: contentWidth, height: max(y - sectionOrigin.y, 0.0))
            sectionRects[indexPath.section] = CGRect(origin: sectionOrigin, size: sectionSize)
        }

        contentHeight = y
    }

    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView where collectionView.numberOfSections() > 0 else {
            return nil
        }

        var layoutAttributes = Array(itemLayoutAttributesCache.values)
        layoutAttributes.appendContentsOf(headerLayoutAttributesCache.values)

        return layoutAttributes.filter({$0.frame.intersects(rect)})
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let _ = collectionView else {
            return nil
        }

        switch elementKind {
        case UICollectionElementKindSectionHeader:
            guard let layoutAttributes = headerLayoutAttributesCache[indexPath] else {
                return nil
            }

            layoutAttributes.frame = headerFrameAtIndexPath(indexPath)

            return layoutAttributes
        default:
            return nil
        }
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributesCache[indexPath]
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        invalidateLayoutWithContext(invalidationContextForBoundsChange(newBounds))

        return super.shouldInvalidateLayoutForBoundsChange(newBounds)
    }

    override func shouldInvalidateLayoutForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if preferredAttributes.representedElementCategory == .Cell {
            preferredItemLayoutAttributesCache[preferredAttributes.indexPath] = preferredAttributes
        }
        else if preferredAttributes.representedElementCategory == .SupplementaryView && preferredAttributes.representedElementKind == UICollectionElementKindSectionHeader {
            preferredHeaderLayoutAttributesCache[preferredAttributes.indexPath] = preferredAttributes
        }

        return !CGSizeEqualToSize(originalAttributes.size, preferredAttributes.size)
    }

//    override func invalidationContextForPreferredLayoutAttributes(preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
//        let context = super.invalidationContextForPreferredLayoutAttributes(preferredAttributes, withOriginalAttributes: originalAttributes)
//
//        context.invalidateItemsAtIndexPaths(Array(itemLayoutAttributesCache.keys))
//        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader, atIndexPaths: Array(headerLayoutAttributesCache.keys))
//
//        return context
//    }

    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)

        guard let collectionView = collectionView where collectionView.numberOfSections() > 0 else {
            return context
        }

        let indexPaths = Array(headerLayoutAttributesCache.keys)
        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader, atIndexPaths: indexPaths)

        return context
    }

    override func invalidateLayout() {
        itemLayoutAttributesCache.removeAll()
        headerLayoutAttributesCache.removeAll()
        sectionRects.removeAll()

        contentWidth = 0.0
        contentHeight = 0.0

        super.invalidateLayout()
    }
}

// MARK: - Private

private extension EventListCollectionViewLayout {
    func headerFrameAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        guard let collectionView = collectionView,
            var frame = headerLayoutAttributesCache[indexPath]?.frame,
            let sectionRect = sectionRects[indexPath.section] else {
                return .zero
        }

        var contentOffset = collectionView.contentOffset
        contentOffset.y += collectionView.contentInset.top

        if sectionRect.contains(contentOffset) {
            frame.origin = contentOffset

            if frame.maxY > sectionRect.maxY {
                frame.origin.y = max(sectionRect.maxY - frame.height, 0.0)
            }
        }
        else if contentOffset.y > sectionRect.maxY {
            frame.origin.y = max(sectionRect.maxY - frame.height, 0.0)
        }
        else {
            frame.origin = sectionRect.origin
        }
        
        return frame
    }
}
