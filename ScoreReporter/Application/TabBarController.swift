//
//  TabBarController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return selectedViewController
    }
}

// MARK: - Private

private extension TabBarController {
    func configureViewControllers() {
        let homeViewModel = HomeViewModel()
        let homeDataSource = HomeDataSource()
        let homeViewController = HomeViewController(viewModel: homeViewModel, dataSource: homeDataSource)
        let homeNavigationController = BaseNavigationController(rootViewController: homeViewController)
        
        let eventsViewModel = EventsViewModel()
        let eventsDataSource = EventsDataSource()
        let eventsViewController = EventsViewController(viewModel: eventsViewModel, dataSource: eventsDataSource)
        let eventsNavigationController = BaseNavigationController(rootViewController: eventsViewController)
        
        let teamsViewModel = TeamsViewModel()
        let teamsDataSource = TeamsDataSource()
        let teamsViewController = TeamsViewController(viewModel: teamsViewModel, dataSource: teamsDataSource)
        let teamsNavigationController = BaseNavigationController(rootViewController: teamsViewController)
        
        let settingsDataSource = SettingsDataSource()
        let settingsViewController = SettingsViewController(dataSource: settingsDataSource)
        let settingsNavigationController = BaseNavigationController(rootViewController: settingsViewController)
        
        let navigationControllers = [
            homeNavigationController,
            eventsNavigationController,
            teamsNavigationController,
            settingsNavigationController
        ]
        
        setViewControllers(navigationControllers, animated: false)
    }
}
