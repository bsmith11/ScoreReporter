//
//  TableViewCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

open class TableViewCell: UITableViewCell {
    fileprivate let separatorView = TableViewCellSeparatorView(frame: .zero)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = false
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension TableViewCell {
    var separatorHidden: Bool {
        get {
            return separatorView.isHidden
        }
        
        set {
            separatorView.isHidden = newValue
        }
    }
}

// MARK: - Private

private extension TableViewCell {
    func configureViews() {
        addSubview(separatorView)
    }
    
    func configureLayout() {
        separatorView.topAnchor == topAnchor - separatorView.frame.height
        separatorView.leadingAnchor == leadingAnchor + 16.0
        separatorView.trailingAnchor == trailingAnchor
    }
}
