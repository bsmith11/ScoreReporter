//
//  DefaultView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/20/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

enum DefaultViewState {
    case None
    case Empty(UIImage?, String?)
    case Loading
    case Error(UIImage?, NSError?)

    var image: UIImage? {
        switch self {
        case .Empty:
            return nil
        case .Error:
            return nil
        default:
            return nil
        }
    }

    var message: String? {
        switch self {
        case .Empty:
            return "No Results Found"
        case .Error:
            return nil
        default:
            return nil
        }
    }
    
    var hidden: Bool {
        switch self {
        case .None:
            return true
        default:
            return false
        }
    }
}

class DefaultView: UIView {
    private let contentStackView = UIStackView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)
    private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    private var states = [DefaultViewState]()
    private var state: DefaultViewState = .None {
        didSet {
            hidden = state.hidden
            
            imageView.image = state.image
            imageView.hidden = state.image == nil
            
            messageLabel.text = state.message
            messageLabel.hidden = state.message == nil
            
            if case .Loading = state {
                spinner.startAnimating()
            }
            else {
                spinner.stopAnimating()
            }
        }
    }
    
    var empty = false {
        didSet {
            configureState()
        }
    }
    
    var loading = false {
        didSet {
            configureState()
        }
    }
    
    var error: NSError? = nil {
        didSet {
            configureState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tintColor = UIColor.USAUNavyColor()

        configureViews()
        configureLayout()

        configureState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()

        imageView.tintColor = tintColor
        spinner.color = tintColor
    }
}

// MARK: - Private

private extension DefaultView {
    func configureViews() {
        contentStackView.axis = .Vertical
        contentStackView.spacing = 20.0
        contentStackView.alignment = .Center
        addSubview(contentStackView)

        imageView.contentMode = .Center
        imageView.tintColor = tintColor
        contentStackView.addArrangedSubview(imageView)

        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        messageLabel.textColor = tintColor
        messageLabel.textAlignment = .Center
        contentStackView.addArrangedSubview(messageLabel)
        
        spinner.color = tintColor
        spinner.hidesWhenStopped = true
        addSubview(spinner)
    }

    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 20.0
        contentStackView.centerYAnchor == centerYAnchor
        
        spinner.centerXAnchor == centerXAnchor
        spinner.centerYAnchor == centerYAnchor
    }
    
    func configureState() {
        switch (empty, loading) {
        case (true, true):
            state = .Loading
        case (true, false):
            if let error = error {
                state = .Error(error)
            }
            else {
                state = .Empty
            }
        case (false, true):
            state = .None
        case (false, false):
            state = .None
        }
    }
}
