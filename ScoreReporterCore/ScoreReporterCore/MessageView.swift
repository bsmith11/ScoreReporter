//
//  MessageView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public enum MessageViewStyle {
    case info
    case error
}

public class MessageView: UIView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    fileprivate var heightConstraint: NSLayoutConstraint?
    
    static var associatedKey = "com.bradsmith.scorereporter.messageViewAssociatedKey"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.messageGreen
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension MessageView {
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    func display(_ display: Bool, animated: Bool) {
        let animations = {
            self.heightConstraint?.isActive = !display
            self.superview?.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        }
        else {
            animations()
        }
    }
}

// MARK: - Private

private extension MessageView {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        heightConstraint = heightAnchor == 0.0
        
        titleLabel.verticalAnchors == (verticalAnchors + 8.0) ~ UILayoutPriorityDefaultLow
        
        let priority = UILayoutPriorityDefaultHigh - 1.0
        titleLabel.horizontalAnchors == (horizontalAnchors + 16.0) ~ priority
    }
}

// MARK: - UILayoutSupport

extension MessageView: UILayoutSupport {
    public var length: CGFloat {
        return bounds.height
    }
}
