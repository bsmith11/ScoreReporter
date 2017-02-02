//
//  CAAnimation+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public extension CASpringAnimation {
    convenience init(keyPath: String, duration: CFTimeInterval) {
        self.init(keyPath: keyPath)

        self.duration = duration

        fillMode = kCAFillModeBoth
        timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        damping = 500.0
        stiffness = 1000.0
        mass = 3.0
    }
}

public extension CABasicAnimation {
    convenience init(keyPath: String, timingFunctionName: String, duration: CFTimeInterval) {
        self.init(keyPath: keyPath)

        self.duration = duration

        fillMode = kCAFillModeBoth
        timingFunction = CAMediaTimingFunction(name: timingFunctionName)
    }

    convenience init(keyPath: String, timingFunction: CAMediaTimingFunction, duration: CFTimeInterval) {
        self.init(keyPath: keyPath)

        self.duration = duration
        self.timingFunction = timingFunction

        fillMode = kCAFillModeBoth
    }
}
