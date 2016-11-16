//
//  TableCollectionViewLayout.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/14/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public class TableCollectionViewLayout: UICollectionViewLayout {
    fileprivate var itemLayoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var headerLayoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    fileprivate var preferredItemLayoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    fileprivate var preferredHeaderLayoutAttributesCache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    fileprivate var sectionRects = [Int: CGRect]()
    fileprivate var sectionLayoutAttributesCache = [Int: [Int: UICollectionViewLayoutAttributes]]()

    fileprivate var contentHeight = CGFloat(0.0)
    fileprivate var contentWidth = CGFloat(0.0)
    
    public var estimatedItemHeight = CGFloat(66.0) {
        didSet {
            invalidateLayout()
        }
    }
    
    public var estimatedHeaderHeight = CGFloat(44.0) {
        didSet {
            invalidateLayout()
        }
    }
    
    public var interitemSpacing = CGFloat(16.0) {
        didSet {
            invalidateLayout()
        }
    }
    
    public var sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0) {
        didSet {
            invalidateLayout()
        }
    }
    
    public override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        print("Prepare layout")
        
        contentWidth = collectionView.bounds.width
        
        let itemWidth = contentWidth  - (sectionInset.left + sectionInset.right)
        let x = CGFloat(0.0)
        var y = CGFloat(0.0)
        
        for section in 0 ..< collectionView.numberOfSections {
            var indexPath = IndexPath(item: 0, section: section)
            
            let headerWidth = collectionView.bounds.width
            let headerHeight = preferredHeaderLayoutAttributesCache[indexPath]?.size.height ?? estimatedHeaderHeight
            let headerFrame = CGRect(x: x, y: y, width: headerWidth, height: headerHeight)
            let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            headerLayoutAttributes.zIndex = 1
            headerLayoutAttributes.frame = headerFrame
            headerLayoutAttributesCache[indexPath] = headerLayoutAttributes
            
            let sectionOrigin = CGPoint(x: x, y: y)
            
            y = headerFrame.maxY + sectionInset.top
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                indexPath = IndexPath(item: item, section: section)
                
                let itemHeight = preferredItemLayoutAttributesCache[indexPath]?.size.height ?? estimatedItemHeight
                let itemFrame = CGRect(x: x + sectionInset.left, y: y, width: itemWidth, height: itemHeight)
                let itemLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemLayoutAttributes.frame = itemFrame
                
                itemLayoutAttributesCache[indexPath] = itemLayoutAttributes
                
                y = itemFrame.maxY
                
                if item < collectionView.numberOfItems(inSection: section) - 1 {
                    y += interitemSpacing
                }
            }
            
            y += sectionInset.bottom
            
            let sectionSize = CGSize(width: contentWidth, height: max(y - sectionOrigin.y, 0.0))
            sectionRects[indexPath.section] = CGRect(origin: sectionOrigin, size: sectionSize)
        }
        
        contentHeight = y
    }

    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
            return nil
        }
        
        var layoutAttributes = Array(itemLayoutAttributesCache.values)
        layoutAttributes.append(contentsOf: headerLayoutAttributesCache.values)
        
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let _ = collectionView else {
            return nil
        }
        
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            guard let layoutAttributes = headerLayoutAttributesCache[indexPath] else {
                return nil
            }
            
//            layoutAttributes.frame = headerFrame(at: indexPath)
            
            return layoutAttributes
        default:
            return nil
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributesCache[indexPath]
    }
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        let context = invalidationContext(forBoundsChange: newBounds)
//        invalidateLayout(with: context)
//        
//        return super.shouldInvalidateLayout(forBoundsChange: newBounds)
//    }
    
    public override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
        if preferredAttributes.representedElementCategory == .cell {
            preferredItemLayoutAttributesCache[preferredAttributes.indexPath] = preferredAttributes
        }
        else if preferredAttributes.representedElementCategory == .supplementaryView && preferredAttributes.representedElementKind == UICollectionElementKindSectionHeader {
            preferredHeaderLayoutAttributesCache[preferredAttributes.indexPath] = preferredAttributes
        }
        
        return !originalAttributes.size.equalTo(preferredAttributes.size)
    }
    
    public override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
//        context.invalidateItemsAtIndexPaths(Array(itemLayoutAttributesCache.keys))
//        context.invalidateSupplementaryElementsOfKind(UICollectionElementKindSectionHeader, atIndexPaths: Array(headerLayoutAttributesCache.keys))
        
        return context
    }

    public override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
            return context
        }
        
//        let indexPaths = Array(headerLayoutAttributesCache.keys)
//        context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: indexPaths)
        
        return context
    }
    
    public override func invalidateLayout() {
        print("Invalidate Layout")
        
        itemLayoutAttributesCache.removeAll()
        headerLayoutAttributesCache.removeAll()
        sectionRects.removeAll()
        
        contentWidth = 0.0
        contentHeight = 0.0
        
        super.invalidateLayout()
    }
}

// MARK: - Private

private extension TableCollectionViewLayout {
    func headerFrame(at indexPath: IndexPath) -> CGRect {
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
