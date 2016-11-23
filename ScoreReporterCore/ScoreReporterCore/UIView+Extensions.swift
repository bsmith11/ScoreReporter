//
//  UIView+Extensions.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public extension UIView {
    func snapshot(rect: CGRect) -> UIView? {
        guard rect.size.width > 0.0 && rect.size.height > 0.0 else {
            return nil
        }
        
        var drawFrame = bounds
        drawFrame.origin.x = -rect.minX
        drawFrame.origin.y = -rect.minY
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        drawHierarchy(in: drawFrame, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(frame: rect)
        imageView.image = image
        
        return imageView
    }
}
