//
//  NavigationItemButtonView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/1/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class NavigationItemButtonView: UIView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    var title: String? {
        return titleLabel.text
    }
    
    var centerPosition: CGPoint {
        let x = ((superview?.bounds.width ?? 0.0) / 2.0) - 3.0 - 6.5
        let y = layer.position.y
        return CGPoint(x: x, y: y)
    }
    
    init?(viewController: UIViewController, backImageWidth: CGFloat) {
        let title = viewController.navigationItem.backBarButtonItem?.title ?? viewController.navigationItem.title ?? "Back"
        let attributes = viewController.navigationItem.backBarButtonItem?.titleTextAttributes(for: .normal) ?? viewController.navigationController?.navigationBar.titleTextAttributes
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        
        let width = max(41.0, backImageWidth + 6.0 + titleLabel.bounds.width)
        let height = max(30.0, titleLabel.bounds.height)
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        super.init(frame: frame)
        
        titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
        titleLabel.frame.origin.x = backImageWidth + 6.0
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
