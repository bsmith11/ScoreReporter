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

        UINavigationBar.appearance().barTintColor = UIColor.USAUNavyColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(18.0, weight: UIFontWeightLight),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes(titleTextAttributes, forState: .Normal)

        let homeViewModel = HomeViewModel()
        let homeDataSource = HomeDataSource()
        let homeViewController = HomeViewController(viewModel: homeViewModel, dataSource: homeDataSource)
        let homeNavigationController = BaseNavigationController(rootViewController: homeViewController)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = homeNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}
