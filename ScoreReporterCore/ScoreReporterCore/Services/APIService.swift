//
//  APIService.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public typealias ServiceCompletion = (ServiceResult) -> Void

public enum ServiceResult {
    case success
    case failure(NSError)
    
    public init(error: Error?) {
        if let error = error as NSError? {
            self = .failure(error)
        }
        else {
            self = .success
        }
    }
}

public class APIService {
    let client: APIClient
    
    public init(client: APIClient = APIClient.sharedInstance) {
        self.client = client
    }
}
