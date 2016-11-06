//
//  NavigationButton.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/1/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

enum NavigationButtonPosition {
    case Left
    case Right
}

class NavigationButton: UIButton {
    init?(viewController: UIViewController, position: NavigationButtonPosition) {
        let item: UIBarButtonItem?
        
        switch position {
        case .Left:
            item = viewController.navigationItem.leftBarButtonItem
        case .Right:
            item = viewController.navigationItem.rightBarButtonItem
        }
        
        guard let barButtonItem = item else {
            return nil
        }
        
        super.init(frame: .zero)
        
        if let image = barButtonItem.image {
            setImage(image, forState: .Normal)
            contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 11.0, bottom: 0.0, right: 11.0)
            tintColor = barButtonItem.tintColor ?? viewController.navigationController?.navigationBar.tintColor
        }
        else if let title = barButtonItem.title {
            let attributes = barButtonItem.titleTextAttributesForState(.Normal)
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            setAttributedTitle(attributedTitle, forState: .Normal)
        }
        
        sizeToFit()
        
        let width = bounds.width
        let height = CGFloat(30.0)
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
