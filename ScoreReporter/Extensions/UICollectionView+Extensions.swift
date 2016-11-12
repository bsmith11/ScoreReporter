//
//  UICollectionView+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionView {
    func register(cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID)
    }

    func register(supplementaryClass: UICollectionReusableView.Type, elementKind: String) {
        register(supplementaryClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: supplementaryClass.reuseID)
    }

    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            preconditionFailure("Cell must of class \(T.reuseID)")
        }

        return cell
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(for elementKind: String, indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            preconditionFailure("Supplementary view must be of class \(T.reuseID)")
        }

        return supplementaryView
    }
}

extension UICollectionView {
    func handle(changes: [FetchedChange], completion: ((Bool) -> Void)? = nil) {
        let updates = { [weak self] in
            changes.forEach { change in
                switch change {
                case .section(let type, let index):
                    let indexSet = IndexSet(integer: index)
                    
                    switch type {
                    case .insert:
                        self?.insertSections(indexSet)
                    case .delete:
                        self?.deleteSections(indexSet)
                    default:
                        break
                    }
                case .object(let type, let indexPath, let newIndexPath):
                    switch type {
                    case .insert:
                        if let newIndexPath = newIndexPath {
                            self?.insertItems(at: [newIndexPath])
                        }
                    case .delete:
                        if let indexPath = indexPath {
                            self?.deleteItems(at: [indexPath])
                        }
                    case .move:
                        if let indexPath = indexPath, let newIndexPath = newIndexPath {
                            self?.moveItem(at: indexPath, to: newIndexPath)
                        }
                    case .update:
                        if let indexPath = indexPath {
                            self?.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }

        performBatchUpdates(updates, completion: completion)
    }
}
