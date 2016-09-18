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
    private let baseURL = NSURL(string: "http://play.usaultimate.org/ajax/api.aspx")!

    init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        manager = Manager(configuration: config, serverTrustPolicyManager: nil)
    }
}

// MARK: - Public

extension APIClient {
    func request(method: Alamofire.Method, path: String, encoding: ParameterEncoding = .URL, parameters: [String: AnyObject]? = nil, completion: APICompletion?) {
        guard let URL = baseURL.URLByAppendingPathComponent(path) else {
            preconditionFailure("Failed to append path: \(path) to baseURL: \(baseURL)")
        }
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        
        let resultTuple = encoding.encode(request, parameters: parameters)
        
        if let error = resultTuple.1 {
            let result = Result<AnyObject, NSError>.Failure(error)
            completion?(result)
        }
        else {
            manager.request(resultTuple.0).validate(statusCode: 200...399).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                completion?(response.result)
            }
        }
    }
}
