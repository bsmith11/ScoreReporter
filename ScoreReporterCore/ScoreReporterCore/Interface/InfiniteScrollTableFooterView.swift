//
//  InfiniteScrollTableFooterView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 2/9/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class InfiniteScrollTableFooterView: UIView {
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate let verticalMargin = CGFloat(16.0)
    
    var loading = false {
        didSet {
            if loading {
                spinner.startAnimating()
            }
            else {
                spinner.stopAnimating()
            }
        }
    }
    
    override init(frame: CGRect) {
        var size = spinner.intrinsicContentSize
        size.height += (2.0 * verticalMargin)
        super.init(frame: CGRect(origin: .zero, size: size))
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        spinner.color = tintColor
    }
}

// MARK: - Private

private extension InfiniteScrollTableFooterView {
    func configureViews() {
        spinner.color = tintColor
        spinner.hidesWhenStopped = true
        addSubview(spinner)
    }
    
    func configureLayout() {
        spinner.verticalAnchors == verticalAnchors + verticalMargin
        spinner.centerXAnchor == centerXAnchor
    }
}
