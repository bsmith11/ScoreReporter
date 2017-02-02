//
//  FloatingPoint+Extensions.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/27/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

//
// https://github.com/Raizlabs/Swiftilities/pull/91
//

public extension FloatingPoint {
    func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamp: Bool = false) -> Self {
        guard source != destination else {
            return self
        }
        
        var result = (((self - source.lowerBound) / (source.upperBound - source.lowerBound)) * (destination.upperBound - destination.lowerBound)) + destination.lowerBound
        
        if clamp {
            result = max(min(result, destination.upperBound), destination.lowerBound)
        }
        
        return result
    }
}
