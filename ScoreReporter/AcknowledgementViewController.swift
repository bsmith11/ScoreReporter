//
//  AcknowledgementViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class AcknowledgementViewController: UIViewController {
    private let acknowledgement: Acknowledgement
    private let textView = UITextView(frame: .zero)
    
    init(acknowledgement: Acknowledgement) {
        self.acknowledgement = acknowledgement
        
        super.init(nibName: nil, bundle: nil)
        
        title = acknowledgement.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
}

// MARK: - Private

private extension AcknowledgementViewController {
    func configureViews() {
        textView.text = acknowledgement.info
        textView.textContainer.lineFragmentPadding = 0.0
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.addSubview(textView)
    }
    
    func configureLayout() {
        textView.edgeAnchors == edgeAnchors
    }
}
