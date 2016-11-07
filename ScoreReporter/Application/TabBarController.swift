//
//  TabBarController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
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
        
        let bookmarksDataSource = BookmarksDataSource()
        let bookmarksViewController = BookmarksViewController(dataSource: bookmarksDataSource)
        let bookmarksNavigationController = BaseNavigationController(rootViewController: bookmarksViewController)
        
        let teamSearchViewModel = TeamSearchViewModel()
        let teamSearchDataSource = TeamSearchDataSource()
        let teamSearchViewController = TeamSearchViewController(viewModel: teamSearchViewModel, dataSource: teamSearchDataSource)
        let teamSearchNavigationController = BaseNavigationController(rootViewController: teamSearchViewController)
        
        let settingsDataSource = SettingsDataSource()
        let settingsViewController = SettingsViewController(dataSource: settingsDataSource)
        let settingsNavigationController = BaseNavigationController(rootViewController: settingsViewController)
        
        let navigationControllers = [
            homeNavigationController,
            bookmarksNavigationController,
            teamSearchNavigationController,
            settingsNavigationController
        ]
        
        setViewControllers(navigationControllers, animated: false)
    }
}
