//
//  UITableView+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func reuseID() -> String {
        return NSStringFromClass(self)
    }
}

extension UITableViewHeaderFooterView {
    static func reuseID() -> String {
        return NSStringFromClass(self)
    }
}

extension UITableView {
    func registerClass(cellClass: UITableViewCell.Type) {
        registerClass(cellClass, forCellReuseIdentifier: cellClass.reuseID())
    }
    
    func registerHeaderFooterClass(headerFooterClass: UITableViewHeaderFooterView.Type) {
        registerClass(headerFooterClass, forHeaderFooterViewReuseIdentifier: headerFooterClass.reuseID())
    }
    
    func dequeueCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithIdentifier(T.reuseID(), forIndexPath: indexPath) as? T else {
            preconditionFailure("Cell must of class \(T.reuseID())")
        }
        
        return cell
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterViewWithIdentifier(T.reuseID()) as? T else {
            preconditionFailure("Header footer view must be of class \(T.reuseID())")
        }
        
        return headerFooterView
    }
}

extension UITableView {
    func handleChanges(changes: [FetchedChange], completion: ((Bool) -> Void)? = nil) {
        beginUpdates()
        
        changes.forEach({ change in
            switch change {
            case .Section(let type, let index):
                let indexSet = NSIndexSet(index: index)
                
                switch type {
                case .Insert:
                    insertSections(indexSet, withRowAnimation: .None)
                case .Delete:
                    deleteSections(indexSet, withRowAnimation: .None)
                default:
                    break
                }
            case .Object(let type, let indexPath, let newIndexPath):
                switch type {
                case .Insert:
                    if let newIndexPath = newIndexPath {
                        insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .None)
                    }
                case .Delete:
                    if let indexPath = indexPath {
                        deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
                case .Move:
                    if let indexPath = indexPath, newIndexPath = newIndexPath {
                        moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
                    }
                case .Update:
                    if let indexPath = indexPath {
                        reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
                }
            }
        })
        
        endUpdates()
        
        completion?(true)
    }
}
