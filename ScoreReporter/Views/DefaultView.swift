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
    case Empty
    case Error
    case Loading

    var image: UIImage? {
        switch self {
        case .None:
            return nil
        case .Empty:
            return nil
        case .Error:
            return nil
        case .Loading:
            return nil
        }
    }

    var message: String? {
        switch self {
        case .None:
            return nil
        case .Empty:
            return nil
        case .Error:
            return nil
        case .Loading:
            return nil
        }
    }
}

class DefaultView: UIView {
    private let contentStackView = UIStackView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)

    var state: DefaultViewState = .None {
        didSet {
            imageView.image = state.image
            messageLabel.text = state.message
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tintColor = UIColor.navyColor()

        configureViews()
        configureLayout()

        state = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()

        imageView.tintColor = tintColor
    }
}

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
    }

    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 20.0
        contentStackView.centerYAnchor == centerYAnchor
    }
}
