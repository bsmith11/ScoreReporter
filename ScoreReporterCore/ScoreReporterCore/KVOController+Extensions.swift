//
//  KVOController+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import KVOController

public extension FBKVOController {
    func observe<T>(_ object: NSObject, keyPath: String, block: @escaping (_ change: T) -> Void) {
        let options: NSKeyValueObservingOptions = [
            .initial,
            .new
        ]

        let internalBlock = { (observer: Any?, object: Any, change: [String: Any]) in
            guard let observedValue = change[NSKeyValueChangeKey.newKey.rawValue] as? T else {
                return
            }

            block(observedValue)
        }

        kvoController.observe(object, keyPath: keyPath, options: options, block: internalBlock)
    }
}
