//
//  AppDelegate.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16
//  Copyright (c) 2016 Brad Smith. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CoreDataStack.configureStack()

        UINavigationBar.appearance().barTintColor = UIColor.navyColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(18.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        let eventListViewModel = EventListViewModel()
        let eventListViewController = EventListViewController(viewModel: eventListViewModel)
        let eventListNavigationController = BaseNavigationController(rootViewController: eventListViewController)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = eventListNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}
