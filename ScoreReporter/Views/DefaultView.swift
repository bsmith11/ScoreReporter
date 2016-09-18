//
//  DefaultView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/20/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public enum DefaultViewState {
    case None
    case Empty
    case Loading
    
    var hidden: Bool {
        switch self {
        case .None:
            return true
        default:
            return false
        }
    }
}

public struct DefaultViewStateInfo {
    let image: UIImage?
    let title: String?
    let message: String?
    
    public init(image: UIImage?, title: String?, message: String?) {
        self.image = image
        self.title = title
        self.message = message
    }
}

public class DefaultView: UIView {
    private let contentStackView = UIStackView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let labelStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    private var stateInfo = [DefaultViewState: DefaultViewStateInfo]()
    private var state: DefaultViewState = .None {
        didSet {
            hidden = state.hidden
            
            let info = stateInfo[state]
            
            imageView.image = info?.image
            imageView.hidden = info?.image == nil
            
            titleLabel.text = info?.title
            titleLabel.hidden = info?.title == nil
            
            messageLabel.text = info?.message
            messageLabel.hidden = info?.message == nil
            
            if case .Loading = state {
                spinner.startAnimating()
            }
            else {
                spinner.stopAnimating()
            }
        }
    }
    
    public var empty = false {
        didSet {
            configureState()
        }
    }
    
    public var loading = false {
        didSet {
            configureState()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = UIColor.USAUNavyColor()
        
        configureViews()
        configureLayout()
        
        configureState()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        imageView.tintColor = tintColor
        titleLabel.textColor = tintColor
        messageLabel.textColor = tintColor
        spinner.color = tintColor
    }
}

// MARK: - Public

public extension DefaultView {
    func setInfo(info: DefaultViewStateInfo, state: DefaultViewState) {
        stateInfo[state] = info
    }
}

// MARK: - Private

private extension DefaultView {
    func configureViews() {
        contentStackView.axis = .Vertical
        contentStackView.spacing = 16.0
        contentStackView.alignment = .Center
        addSubview(contentStackView)
        
        imageView.contentMode = .Center
        imageView.tintColor = tintColor
        contentStackView.addArrangedSubview(imageView)
        
        labelStackView.axis = .Vertical
        labelStackView.spacing = 8.0
        contentStackView.addArrangedSubview(labelStackView)
        
        titleLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightBold)
        titleLabel.textColor = tintColor
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.textAlignment = .Center
        labelStackView.addArrangedSubview(titleLabel)
        
        messageLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        messageLabel.textColor = tintColor
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.textAlignment = .Center
        labelStackView.addArrangedSubview(messageLabel)
        
        spinner.color = tintColor
        spinner.hidesWhenStopped = true
        addSubview(spinner)
    }
    
    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 48.0
        contentStackView.centerYAnchor == centerYAnchor
        
        spinner.centerXAnchor == centerXAnchor
        spinner.centerYAnchor == centerYAnchor
    }
    
    func configureState() {
        switch (empty, loading) {
        case (true, true):
            state = .Loading
        case (true, false):
            state = .Empty
        case (false, true):
            state = .None
        case (false, false):
            state = .None
        }
    }
}
