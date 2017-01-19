//
//  Sequence+Extensions.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 1/19/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public extension Sequence where Iterator.Element == String? {
    func joined(by separator: String) -> String? {
        let string = flatMap { $0 }.joined(separator: separator)
        return string.isEmpty ? nil : string
    }
}
