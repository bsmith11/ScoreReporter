//
//  EventCell.swift
//  ScoreReporter
//
//  Created by Brad Smith on 3/31/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage
import ScoreReporterCore

public class EventCell: TableViewCell {
    fileprivate let listContentView = ListContentView(frame: .zero)
    
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
        
        listContentView.cancelImageDownload()
    }
}

// MARK: - Public

public extension EventCell {
    func configure(with event: Event?) {
        guard let event = event else {
            return
        }
        
        let viewModel = EventViewModel(event: event)
        listContentView.configure(withViewModel: viewModel)
    }
    
    func configure(withViewModel viewModel: EventViewModel) {
        listContentView.configure(withViewModel: viewModel)
    }
}

// MARK: - Private

private extension EventCell {
    func configureViews() {
        contentView.addSubview(listContentView)
    }
    
    func configureLayout() {
        listContentView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
