//
//  UICollectionView+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static func reuseID() -> String {
        return NSStringFromClass(self)
    }
}

extension UICollectionView {
    func registerClass(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseID())
    }

    func registerClass(_ supplementaryClass: UICollectionReusableView.Type, elementKind: String) {
        register(supplementaryClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: supplementaryClass.reuseID())
    }

    func dequeueCellForIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID(), for: indexPath) as? T else {
            preconditionFailure("Cell must of class \(T.reuseID())")
        }

        return cell
    }

    func dequeueSupplementaryViewForElementKind<T: UICollectionReusableView>(_ elementKind: String, indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseID(), for: indexPath) as? T else {
            preconditionFailure("Supplementary view must be of class \(T.reuseID())")
        }

        return supplementaryView
    }
}

extension UICollectionView {
    func handleChanges(_ changes: [FetchedChange], completion: ((Bool) -> Void)? = nil) {
        let updates = { [weak self] in
            changes.forEach({ change in
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
            })
        }

        performBatchUpdates(updates, completion: completion)
    }
}
