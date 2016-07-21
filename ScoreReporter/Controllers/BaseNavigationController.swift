//
//  BaseNavigationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }
}
