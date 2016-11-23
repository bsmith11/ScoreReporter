//
//  Sizable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/12/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

public protocol Sizable {
    func size(with width: CGFloat) -> CGSize
}

public extension Sizable where Self: UICollectionViewCell {
    func size(with width: CGFloat) -> CGSize {
        let targetSize = CGSize(width: width, height: UILayoutFittingCompressedSize.height)
        return contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
    }
}
