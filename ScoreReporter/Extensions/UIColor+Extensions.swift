//
//  UIColor+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        if hexString.hasPrefix("#") {
            let index = hexString.startIndex.advancedBy(1)
            let hex = hexString.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0

            if scanner.scanHexLongLong(&hexValue) {
                switch hex.characters.count {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            }
            else {
                print("Scan hex error")
            }
        }
        else {
            print("Invalid RGB string, missing '#' as prefix")
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    static var scRed: UIColor {
        return UIColor(hexString: "#DF5F6D")
    }
    
    static var scBlue: UIColor {
        return UIColor(hexString: "#4C69AB")
    }
    
    static func USAUNavyColor() -> UIColor {
        return UIColor(hexString: "#001E42")
    }
    
    static func USAURedColor() -> UIColor {
        return UIColor(hexString: "#B20838")
    }
    
    static func messageGreenColor() -> UIColor {
        return UIColor(hexString: "#32B92D")
    }
}
