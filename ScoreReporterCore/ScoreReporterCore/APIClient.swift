//
//  APIClient.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public typealias APICompletion = (Result<Any>) -> Void

public class APIClient {
    public static let sharedInstance = APIClient()

    fileprivate let manager: SessionManager
    //TODO: - Remove force unwrap
    fileprivate let baseURL = URL(string: "https://play.usaultimate.org/ajax/api.aspx")!

    private init() {
        let config = URLSessionConfiguration.default
        manager = SessionManager(configuration: config, serverTrustPolicyManager: nil)
    }
}

// MARK: - Public

public extension APIClient {
    func request(_ method: HTTPMethod, path: String, encoding: ParameterEncoding = URLEncoding.default, parameters: [String: Any]? = nil, completion: APICompletion?) {
        let URL = baseURL.appendingPathComponent(path)

        manager.request(URL, method: method, parameters: parameters, encoding: encoding, headers: nil).validate(statusCode: 200...399).responseJSON { response -> Void in
            completion?(response.result)
        }
    }
}
