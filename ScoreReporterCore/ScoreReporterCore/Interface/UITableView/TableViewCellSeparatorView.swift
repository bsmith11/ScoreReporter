//
//  TableViewCellSeparatorView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public class TableViewCellSeparatorView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        let height = 1.0 / UIScreen.main.scale
        return CGSize(width: bounds.width, height: height)
    }
}
