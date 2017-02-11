//
//  EmptyContentView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 2/10/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public class EmptyContentView: UIView {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let labelStackView = UIStackView(frame: .zero)
    
    public let imageView = UIImageView(frame: .zero)
    public let titleLabel = UILabel(frame: .zero)
    public let messageLabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = UIColor.gray
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        imageView.tintColor = tintColor
        titleLabel.textColor = tintColor
        messageLabel.textColor = tintColor
    }
}

// MARK: - Public

public extension EmptyContentView {
    func configure(withImage image: UIImage?, title: String?, message: String?) {
        imageView.image = image
        imageView.isHidden = imageView.image == nil
        
        titleLabel.text = title
        titleLabel.isHidden = titleLabel.text == nil
        
        messageLabel.text = message
        messageLabel.isHidden = messageLabel.text == nil
    }
}

// MARK: - Private

private extension EmptyContentView {
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
    }

    func configureLayout() {
        contentStackView.horizontalAnchors <= horizontalAnchors + 32.0
        contentStackView.centerYAnchor == centerYAnchor
    }
}
