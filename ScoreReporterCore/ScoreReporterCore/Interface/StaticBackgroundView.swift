//
//  StaticBackgroundView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit

open class StaticBackgroundView: UIView {
    override open var backgroundColor: UIColor? {
        didSet {
            if let color = backgroundColor, color.cgColor.alpha.isEqual(to: 0.0) {
                backgroundColor = oldValue
            }
        }
    }
}
