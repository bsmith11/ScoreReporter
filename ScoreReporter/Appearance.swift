//
//  Appearance.swift
//  ScoreReporter
//
//  Created by Brad Smith on 3/31/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit

struct Appearance {
    static func configure() {
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
}