//
//  NSError+Extensions.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public enum ErrorType {
    case invalidResponse
    case invalidAccessToken
    case importFailure
    case invalidUserToken
    case emptyResponse
    
    var message: String {
        switch self {
        case .invalidResponse:
            return "Invalid response structure"
        case .invalidAccessToken:
            return "No access token"
        case .importFailure:
            return "Failed to import User"
        case .invalidUserToken:
            return "Please login to access this feature"
        case .emptyResponse:
            return "Empty response"
        }
    }
}

public extension NSError {
    private static var messageKey: String {
        return "com.bradsmith.ScoreReporter.error.message"
    }
    
    convenience init(message: String) {
        let userInfo = [
            NSError.messageKey: message
        ]
        
        self.init(domain: "com.bradsmith.ScoreReporter", code: 0, userInfo: userInfo)
    }
    
    convenience init(type: ErrorType) {
        self.init(message: type.message)
    }
    
    var message: String? {
        return userInfo[NSError.messageKey] as? String
    }
}
