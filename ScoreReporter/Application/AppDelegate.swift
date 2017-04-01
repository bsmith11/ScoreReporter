//
//  AppDelegate.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16
//  Copyright (c) 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore

@UIApplicationMain
class AppDelegate: UIResponder {
    fileprivate var deepLinkCoordinator: DeepLinkCoordinator?
    
    var window: UIWindow?
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStack.sharedInstance

        Appearance.configure()

        let tabBarController = TabBarController(nibName: nil, bundle: nil)
        deepLinkCoordinator = DeepLinkCoordinator(rootViewController: tabBarController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        deepLinkCoordinator?.handle(url: url)
        
        return true
    }
}
