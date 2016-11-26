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
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 0.5
        animation.values = [
            NSValue(cgPoint: CGPoint(x: layer.position.x - 10.0, y: layer.position.y)),
            NSValue(cgPoint: CGPoint(x: layer.position.x + 8.0, y: layer.position.y)),
            NSValue(cgPoint: CGPoint(x: layer.position.x - 6.0, y: layer.position.y)),
            NSValue(cgPoint: CGPoint(x: layer.position.x + 4.0, y: layer.position.y)),
            NSValue(cgPoint: CGPoint(x: layer.position.x - 2.0, y: layer.position.y)),
            NSValue(cgPoint: layer.position)
        ]
        
        animation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        ]
        
        layer.add(animation, forKey: #keyPath(CALayer.position))
    }
}
