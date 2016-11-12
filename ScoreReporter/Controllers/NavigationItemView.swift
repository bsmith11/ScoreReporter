//
//  NavigationItemView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/1/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class NavigationItemView: UIView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    var title: String? {
        return titleLabel.text
    }
    
    var centerPosition: CGPoint {
        let x = (superview?.bounds.width ?? 0.0) / 2.0
        let y = layer.position.y
        return CGPoint(x: x, y: y)
    }
    
    init?(viewController: UIViewController) {
        guard let title = viewController.title else {
            return nil
        }
        
        let attributes = viewController.navigationController?.navigationBar.titleTextAttributes
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        
        let width = titleLabel.bounds.width
        let height = max(27.0, titleLabel.bounds.height)
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        super.init(frame: frame)
        
        titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
