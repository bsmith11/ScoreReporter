//
//  APIResult.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 1/6/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public enum APIResult<Value> {
    case success(Value)
    case failure(Error)
}

public extension APIResult {
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
