//
//  EventViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/20/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    init(viewModel: EventViewModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
    }
}
