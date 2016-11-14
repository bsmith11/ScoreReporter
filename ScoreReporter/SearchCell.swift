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

class SearchCell: UICollectionViewCell, Sizable {
    fileprivate let searchInfoView = SearchInfoView(frame: .zero)
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : CGAffineTransform.identity
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    class func size(with searchable: Searchable?, width: CGFloat) -> CGSize {
        guard let searchable = searchable else {
            return .zero
        }
        
        let cell = SearchCell(frame: .zero)
        cell.configure(with: searchable)
        
        return cell.size(with: width)
    }
}

// MARK: - Private

private extension SearchCell {
    func configureViews() {
        contentView.addSubview(searchInfoView)
    }
    
    func configureLayout() {
        searchInfoView.edgeAnchors == contentView.edgeAnchors
    }
}
