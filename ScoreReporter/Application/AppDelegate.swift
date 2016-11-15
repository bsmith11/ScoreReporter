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
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStack.sharedInstance

        UINavigationBar.appearance().barTintColor = UIColor.scBlue
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBlack),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        let titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBlack),
            NSForegroundColorAttributeName: UIColor.white
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(titleTextAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        UITabBar.appearance().barTintColor = UIColor.scBlue
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor.white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 49.0)
//        UITabBarItem.appearance().imageInsets = UIEdgeInsets(top: 11.5, left: 0.0, bottom: 0.0, right: 0.0)
        
        let tabBarController = TabBarController(nibName: nil, bundle: nil)
//        let loginViewModel = LoginViewModel()
//        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
//        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()

        return true
    }
}
