//
//  KVOController+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import KVOController

extension FBKVOController {
    func observe<T>(object: NSObject, keyPath: String, block: (change: T) -> Void) {
        let options: NSKeyValueObservingOptions = [
            .Initial,
            .New
        ]
        
        let internalBlock = { (observer: AnyObject?, object: AnyObject, change: [String: AnyObject]) in
            guard let observedValue = change[NSKeyValueChangeNewKey] as? T else {
                return
            }
            
            block(change: observedValue)
        }
        
        KVOController.observe(object, keyPath: keyPath, options: options, block: internalBlock)
    }    
}
