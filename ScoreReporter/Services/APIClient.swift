//
//  APIClient.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

typealias APICompletion = Result<AnyObject, NSError> -> Void

class APIClient {
    static let sharedInstance = APIClient()

    private let manager: Manager

    init() {
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        manager = Manager(configuration: config, serverTrustPolicyManager: nil)
    }
}

// MARK: - Public

extension APIClient {
    func request(route: URLRequestConvertible, completion: APICompletion?) {
        manager.request(route).validate(statusCode: 200...399).responseJSON { response -> Void in
            completion?(response.result)
        }
    }
}
