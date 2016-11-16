//
//  UITableView+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}

public extension UITableViewHeaderFooterView {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}

public extension UITableView {
    func register(cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseID)
    }
    
    func register(headerFooterClass: UITableViewHeaderFooterView.Type) {
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseID)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            preconditionFailure("Cell must of class \(T.reuseID)")
        }
        
        return cell
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            preconditionFailure("Header footer view must be of class \(T.reuseID)")
        }
        
        return headerFooterView
    }
}

public extension UITableView {
    func handle(changes: [FetchedChange], completion: ((Bool) -> Void)? = nil) {
        beginUpdates()
        
        changes.forEach { change in
            switch change {
            case .section(let type, let index):
                let indexSet = IndexSet(integer: index)
                
                switch type {
                case .insert:
                    insertSections(indexSet, with: .none)
                case .delete:
                    deleteSections(indexSet, with: .none)
                default:
                    break
                }
            case .object(let type, let indexPath, let newIndexPath):
                switch type {
                case .insert:
                    if let newIndexPath = newIndexPath {
                        insertRows(at: [newIndexPath], with: .none)
                    }
                case .delete:
                    if let indexPath = indexPath {
                        deleteRows(at: [indexPath], with: .none)
                    }
                case .move:
                    if let indexPath = indexPath, let newIndexPath = newIndexPath {
                        moveRow(at: indexPath, to: newIndexPath)
                    }
                case .update:
                    if let indexPath = indexPath {
                        reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
        }
        
        endUpdates()
        
        completion?(true)
    }
}
