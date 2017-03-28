//
//  APIService.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public class APIService {
    let client: APIClient
    
    public init(client: APIClient = APIClient.sharedInstance) {
        self.client = client
    }
}
