//
//  TeamCell.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

public class TeamCell: TableViewCell {
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

public extension TeamCell {
    func configure(with team: ManagedTeam?) {
        searchInfoView.configure(with: team)
    }
}

// MARK: - Private

private extension TeamCell {
    func configureViews() {
        contentView.addSubview(searchInfoView)
    }

    func configureLayout() {
        searchInfoView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
