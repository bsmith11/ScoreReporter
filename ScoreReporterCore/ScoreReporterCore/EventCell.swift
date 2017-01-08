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

public class EventCell: TableViewCell {
    fileprivate let searchInfoView = SearchInfoView(frame: .zero)

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        configureLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        searchInfoView.cancelImageDownload()
    }
}

// MARK: - Public

public extension EventCell {
    func configure(with event: Event?) {
        searchInfoView.configure(with: event)
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
