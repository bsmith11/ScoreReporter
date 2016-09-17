//
//  UIViewController+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UIViewController {
    func deselectRowsInTableView(tableView: UITableView, animated: Bool) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        if let transitionCoordinator = transitionCoordinator() {
            let animation = { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                tableView.deselectRowAtIndexPath(indexPath, animated: animated)
            }
            
            let completion = { (context: UIViewControllerTransitionCoordinatorContext) in
                if context.isCancelled() {
                    tableView.selectRowAtIndexPath(indexPath, animated: animated, scrollPosition: .None)
                }
            }
            
            transitionCoordinator.animateAlongsideTransition(animation, completion: completion)
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
}
