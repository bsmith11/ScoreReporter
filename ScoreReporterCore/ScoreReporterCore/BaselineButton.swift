//
//  BaselineButton.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/14/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

open class BaselineButton: UIButton {
    override open var forLastBaselineLayout: UIView {
        return titleLabel ?? self
    }
}
