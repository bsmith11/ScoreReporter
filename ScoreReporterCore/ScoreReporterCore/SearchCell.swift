//
//  SearchCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class SearchCell: TableViewCell {
    fileprivate let searchInfoView = SearchInfoView(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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

extension SearchCell {
    func configure(with searchable: Searchable?) {
        searchInfoView.configure(with: searchable)
    }
}

// MARK: - Private

private extension SearchCell {
    func configureViews() {
        contentView.addSubview(searchInfoView)
    }
    
    func configureLayout() {
        searchInfoView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
