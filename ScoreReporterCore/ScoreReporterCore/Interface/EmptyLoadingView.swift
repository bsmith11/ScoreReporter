//
//  EmptyLoadingView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 6/21/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public class EmptyLoadingView: UIView {
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    public var loading = false {
        didSet {
            if loading {
                spinner.startAnimating()
            }
            else {
                spinner.stopAnimating()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureSubviews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        spinner.tintColor = tintColor
    }
}

// MARK: - Private

private extension EmptyLoadingView {
    func configureSubviews() {
        spinner.hidesWhenStopped = true
        spinner.tintColor = tintColor
    }
    
    func configureLayout() {
        spinner.centerXAnchor == centerXAnchor
        spinner.centerYAnchor == centerYAnchor
    }
}
