//
//  EventCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class EventCell: TableViewCell {
    fileprivate let searchInfoView = SearchInfoView(frame: .zero)
    
    var contentFrame: CGRect {
        return searchInfoView.frame
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        searchInfoView.cancelImageDownload()
    }
}

// MARK: - Public

extension EventCell {
    func configure(with event: Event?) {
        searchInfoView.configure(with: event)
    }
    
    func contentFrameFrom(view: UIView) -> CGRect {
        return view.convert(searchInfoView.frame, from: searchInfoView.superview)
    }
}

// MARK: - Private

private extension EventCell {
    func configureViews() {
        contentView.addSubview(searchInfoView)
    }
    
    func configureLayout() {
        searchInfoView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
