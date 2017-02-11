//
//  ProtocolInterceptor.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 2/9/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

class ProtocolInterceptor: NSObject {
    weak var interceptor: NSObjectProtocol?
    weak var receiver: NSObjectProtocol?
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let interceptor = interceptor, interceptor.responds(to: aSelector) {
            return interceptor
        }
        else if let receiver = receiver, receiver.responds(to: aSelector) {
            return receiver
        }
        else {
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if let interceptor = interceptor, interceptor.responds(to: aSelector) {
            return true
        }
        else if let receiver = receiver, receiver.responds(to: aSelector) {
            return true
        }
        else {
            return super.responds(to: aSelector)
        }
    }
}
