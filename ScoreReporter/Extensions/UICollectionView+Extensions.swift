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
    func registerClass(cellClass: UICollectionViewCell.Type) {
        registerClass(cellClass, forCellWithReuseIdentifier: cellClass.reuseID())
    }

    func registerClass(supplementaryClass: UICollectionReusableView.Type, elementKind: String) {
        registerClass(supplementaryClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: supplementaryClass.reuseID())
    }

    func dequeueCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.reuseID(), forIndexPath: indexPath) as? T else {
            preconditionFailure("Cell must of class \(T.reuseID())")
        }

        return cell
    }

    func dequeueSupplementaryViewForElementKind<T: UICollectionReusableView>(elementKind: String, indexPath: NSIndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: T.reuseID(), forIndexPath: indexPath) as? T else {
            preconditionFailure("Supplementary view must be of class \(T.reuseID())")
        }

        return supplementaryView
    }
}

extension UICollectionView {
    func handleChanges(changes: [FetchedChange], completion: ((Bool) -> Void)? = nil) {
        let updates = { [weak self] in
            changes.forEach({ change in
                switch change {
                case .Section(let type, let index):
                    let indexSet = NSIndexSet(index: index)
                    
                    switch type {
                    case .Insert:
                        self?.insertSections(indexSet)
                    case .Delete:
                        self?.deleteSections(indexSet)
                    default:
                        break
                    }
                case .Object(let type, let indexPath, let newIndexPath):
                    switch type {
                    case .Insert:
                        if let newIndexPath = newIndexPath {
                            self?.insertItemsAtIndexPaths([newIndexPath])
                        }
                    case .Delete:
                        if let indexPath = indexPath {
                            self?.deleteItemsAtIndexPaths([indexPath])
                        }
                    case .Move:
                        if let indexPath = indexPath, newIndexPath = newIndexPath {
                            self?.moveItemAtIndexPath(indexPath, toIndexPath: newIndexPath)
                        }
                    case .Update:
                        if let indexPath = indexPath {
                            self?.reloadItemsAtIndexPaths([indexPath])
                        }
                    }
                }
            })
        }

        performBatchUpdates(updates, completion: completion)
    }
}
