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
    var window: UIWindow?
}

// MARK: - Private

private extension AppDelegate {
    func configureAppearance() {
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
    }
    
    func handle(url: URL) {
        guard let host = url.host else {
            print("Invalid URL: No host")
            return
        }
        
        guard let tabBarController = window?.rootViewController as? TabBarController else {
            print("Invalid view heirarchy")
            return
        }
        
        switch host {
        case "events":
            guard let eventID = url.pathComponents.last.flatMap({ Int($0) }),
                  let event = Event.object(primaryKey: NSNumber(value: eventID), context: Event.coreDataStack.mainContext),
                  let navigationController = tabBarController.selectedViewController as? UINavigationController else {
                return
            }
            
            let viewModel = EventViewModel(event: event)
            let dataSource = EventDetailsDataSource(viewModel: viewModel)
            let viewController = EventDetailsViewController(dataSource: dataSource)
            
            navigationController.pushViewController(viewController, animated: false)
        case "games":
            break
        default:
            print("Invalid URL: Unknown host \(host)")
            break
        }
    }
}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = CoreDataStack.sharedInstance

        configureAppearance()

        let tabBarController = TabBarController(nibName: nil, bundle: nil)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        handle(url: url)
        
        return true
    }
}
