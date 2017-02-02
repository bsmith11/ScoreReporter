//
//  String+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public extension String {
    func matching(regexPattern: String) -> String? {
        var strings = [String]()

        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            let options: NSRegularExpression.MatchingOptions = .reportProgress
            let range = NSRange(location: 0, length: (self as NSString).length)

            regex.enumerateMatches(in: self, options: options, range: range) { (result: NSTextCheckingResult?, _, _) in
                if let result = result {
                    let match = (self as NSString).substring(with: result.range)
                    strings.append(match)
                }
            }

            return strings.first
        }
        catch let error {
            print("Failed to create regular expression with pattern: \(regexPattern) error: \(error)")

            return nil
        }
    }
}
