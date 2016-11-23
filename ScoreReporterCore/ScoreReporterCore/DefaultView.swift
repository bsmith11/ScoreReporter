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
    case none
    case empty
    case loading

    var hidden: Bool {
        switch self {
        case .none:
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
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let imageView = UIImageView(frame: .zero)
    fileprivate let labelStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let messageLabel = UILabel(frame: .zero)
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    fileprivate var stateInfo = [DefaultViewState: DefaultViewStateInfo]()
    fileprivate var state: DefaultViewState = .none {
        didSet {
            isHidden = state.hidden

            let info = stateInfo[state]

            imageView.image = info?.image
            imageView.isHidden = info?.image == nil

            titleLabel.text = info?.title
            titleLabel.isHidden = info?.title == nil

            messageLabel.text = info?.message
            messageLabel.isHidden = info?.message == nil

            if case .loading = state {
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

    override public init(frame: CGRect) {
        super.init(frame: frame)

        tintColor = UIColor.gray

        configureViews()
        configureLayout()

        configureState()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func tintColorDidChange() {
        super.tintColorDidChange()

        imageView.tintColor = tintColor
        titleLabel.textColor = tintColor
        messageLabel.textColor = tintColor
        spinner.color = tintColor
    }
}

// MARK: - Public

public extension DefaultView {
    func setInfo(_ info: DefaultViewStateInfo, state: DefaultViewState) {
        stateInfo[state] = info
    }
}

// MARK: - Private

private extension DefaultView {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 16.0
        contentStackView.alignment = .center
        addSubview(contentStackView)

        imageView.contentMode = .center
        imageView.tintColor = tintColor
        contentStackView.addArrangedSubview(imageView)

        labelStackView.axis = .vertical
        labelStackView.spacing = 8.0
        contentStackView.addArrangedSubview(labelStackView)

        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBlack)
        titleLabel.textColor = tintColor
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        labelStackView.addArrangedSubview(titleLabel)

        messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        messageLabel.textColor = tintColor
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
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
            state = .loading
        case (true, false):
            state = .empty
        case (false, true):
            state = .none
        case (false, false):
            state = .none
        }
    }
}
