//
//  KVOController+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import KVOController

public typealias FBKVOChangeBlock<T> = (T) -> Void

public extension FBKVOController {
    func observe<T>(_ object: NSObject, keyPath: String, block: @escaping FBKVOChangeBlock<T>) {
        let options: NSKeyValueObservingOptions = [
            .initial,
            .new
        ]

        observe(object, keyPath: keyPath, options: options) { (_, _, change) in
            guard let observedValue = change[NSKeyValueChangeKey.newKey.rawValue] as? T else {
                return
            }
            
            block(observedValue)
        }
    }
}
