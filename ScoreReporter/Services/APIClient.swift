//
//  APIClient.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

typealias APICompletion = (Result<Any>) -> Void

class APIClient {
    static let sharedInstance = APIClient()

    fileprivate let manager: SessionManager
    fileprivate let baseURL = URL(string: "https://play.usaultimate.org/ajax/api.aspx")!

    init() {
        let config = URLSessionConfiguration.default
        manager = SessionManager(configuration: config, serverTrustPolicyManager: nil)
    }
}

// MARK: - Public

extension APIClient {
    func request(_ method: HTTPMethod, path: String, encoding: ParameterEncoding = URLEncoding.default, parameters: [String: Any]? = nil, completion: APICompletion?) {
        let URL = baseURL.appendingPathComponent(path)
        
        manager.request(URL, method: method, parameters: parameters, encoding: encoding, headers: nil).validate(statusCode: 200...399).responseJSON { response -> Void in
            completion?(response.result)
        }
    }
}
