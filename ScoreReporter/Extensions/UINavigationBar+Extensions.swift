//
//  UINavigationBar+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/30/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func titleViewWithTitle(_ title: String?) -> UIView? {
        guard let title = title else {
            return nil
        }
        
        return subviews.filter({ view -> Bool in
            guard view.responds(to: #selector(getter: UIBarItem.title)) else {
                return false
            }
            
            return (view.value(forKeyPath: "title") as? String) == title
        }).first
    }
}
