//
//  MessageView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

enum MessageViewStyle {
    case Info
    case Error
}

class MessageView: UIView {
    private let titleLabel = UILabel(frame: .zero)
    
    private var heightConstraint: NSLayoutConstraint?
    
    static var associatedKey = "com.bradsmith.scorereporter.messageViewAssociatedKey"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.messageGreenColor()
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension MessageView {
    func configureWithTitle(title: String) {
        titleLabel.text = title
    }
    
    func display(display: Bool, animated: Bool) {
        let animations = {
            self.heightConstraint?.active = !display
            self.superview?.layoutIfNeeded()
        }
        
        if animated {
            UIView.animateWithDuration(0.3, animations: animations)
        }
        else {
            animations()
        }
    }
}

// MARK: - Private

private extension MessageView {
    func configureViews() {
        titleLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.textAlignment = .Center
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        heightConstraint = heightAnchor == 0.0
        
        titleLabel.verticalAnchors == verticalAnchors + 16.0 ~ UILayoutPriorityDefaultLow
        titleLabel.horizontalAnchors == horizontalAnchors + 16.0 ~ UILayoutPriorityDefaultHigh - 1.0
    }
}

// MARK: - UILayoutSupport

extension MessageView: UILayoutSupport {
    var length: CGFloat {
        return bounds.height
    }
}
