//
//  Credentials.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Credentials {
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
