//
//  CollectionViewProxy.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/14/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewProxyDataSource: class {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
}

protocol CollectionViewProxyDelegate: class {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class CollectionViewProxy: NSObject {
    fileprivate unowned let dataSource: CollectionViewProxyDataSource
    fileprivate unowned let delegate: CollectionViewProxyDelegate

    init(dataSource: CollectionViewProxyDataSource, delegate: CollectionViewProxyDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension CollectionViewProxy: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections(in: collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

extension CollectionViewProxy: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return delegate.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
