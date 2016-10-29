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
        CoreDataStack.sharedInstance

        UINavigationBar.appearance().barTintColor = UIColor.USAUNavyColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(17.0, weight: UIFontWeightBlack),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(17.0, weight: UIFontWeightBlack),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, forState: .Normal)
        
        UITabBar.appearance().barTintColor = UIColor.USAUNavyColor()
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        let tabBarController = TabBarController(nibName: nil, bundle: nil)
//        let loginViewController = LoginViewController(nibName: nil, bundle: nil)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController
//        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()

        return true
    }
}
