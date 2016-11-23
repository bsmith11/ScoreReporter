//
//  UIViewController+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public extension UIViewController {
    func deselectRows(in tableView: UITableView, animated: Bool) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

        if let transitionCoordinator = transitionCoordinator {
            let animation = { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                tableView.deselectRow(at: indexPath, animated: animated)
            }

            let completion = { (context: UIViewControllerTransitionCoordinatorContext) in
                if context.isCancelled {
                    tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
                }
            }

            transitionCoordinator.animate(alongsideTransition: animation, completion: completion)
        }
        else {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
}
