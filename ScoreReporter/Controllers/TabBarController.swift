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

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}

// MARK: - Private

private extension TabBarController {
    func configureViewControllers() {
        let homeDataSource = HomeDataSource()
        let homeViewController = HomeViewController(dataSource: homeDataSource)
        let homeNavigationController = BaseNavigationController(rootViewController: homeViewController)

        let eventListDataSource = EventListDataSource()
        let eventListViewController = EventListViewController(dataSource: eventListDataSource)
        let eventListNavigationController = BaseNavigationController(rootViewController: eventListViewController)

        let teamListDataSource = TeamListDataSource()
        let teamListViewController = TeamListViewController(dataSource: teamListDataSource)
        let teamListNavigationController = BaseNavigationController(rootViewController: teamListViewController)

        let settingsDataSource = SettingsDataSource()
        let settingsViewController = SettingsViewController(dataSource: settingsDataSource)
        let settingsNavigationController = BaseNavigationController(rootViewController: settingsViewController)

        let navigationControllers = [
            homeNavigationController,
            eventListNavigationController,
            teamListNavigationController,
            settingsNavigationController
        ]

//        eventsViewModel.downloadEvents()
//        teamsViewModel.downloadTeams()

        setViewControllers(navigationControllers, animated: false)
    }
}
