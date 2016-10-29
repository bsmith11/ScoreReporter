//
//  String+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

extension String {
    func stringMatchingRegexPattern(pattern: String) -> String? {
        var strings = [String]()

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            let options: NSMatchingOptions = .ReportProgress
            let range = NSRange(location: 0, length: (self as NSString).length)

            regex.enumerateMatchesInString(self, options: options, range: range, usingBlock: { (result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) in
                if let result = result {
                    let match = (self as NSString).substringWithRange(result.range)
                    strings.append(match)
                }
            })

            return strings.first
        }
        catch _ {
            print("Failed to create regular expression with pattern: \(pattern)")

            return nil
        }
    }    
}
