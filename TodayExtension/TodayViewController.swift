//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    fileprivate let label = UILabel(frame: .zero)
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

// MARK: - Private

private extension TodayViewController {
    func configureViews() {
        label.text = "Hello World"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }
    
    func configureLayout() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
