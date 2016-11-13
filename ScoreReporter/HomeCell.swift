//
//  HomeCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class HomeCell: UICollectionViewCell, Sizable {
    fileprivate let eventInfoView = EventInfoView(frame: .zero)
    
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
        
        eventInfoView.cancelImageDownload()
    }
}

// MARK: - Public

extension HomeCell {
    func configure(with event: Event?) {
        eventInfoView.configure(with: event)
    }
    
    class func size(with event: Event?, width: CGFloat) -> CGSize {
        guard let event = event else {
            return .zero
        }
        
        let cell = HomeCell(frame: .zero)
        cell.configure(with: event)
        
        return cell.size(with: width)
    }
}

// MARK: - Private

private extension HomeCell {
    func configureViews() {
        contentView.addSubview(eventInfoView)
    }
    
    func configureLayout() {
        eventInfoView.edgeAnchors == contentView.edgeAnchors
    }
}
