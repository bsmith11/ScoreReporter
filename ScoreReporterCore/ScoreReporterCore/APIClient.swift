//
//  APIClient.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public typealias APICompletion = (APIResult<[String: Any]>) -> Void

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

public enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public class APIClient {
    public static let sharedInstance = APIClient()

    fileprivate let manager: SessionManager
    fileprivate let baseURL: URL = {
        guard let url = URL(string: APIConstants.Path.baseURL) else {
            fatalError("Failed to initialize baseURL: \(APIConstants.Path.baseURL)")
        }

        let pathComponent = "ajax/api.aspx"

        return url.appendingPathComponent(pathComponent)
    }()

    private init() {
        let config = URLSessionConfiguration.default
        manager = SessionManager(configuration: config, serverTrustPolicyManager: nil)
    }
}

// MARK: - Public

public extension APIClient {
    func request(_ method: APIMethod, path: String, parameters: [String: Any]? = nil, completion: APICompletion?) {
        let URL = baseURL.appendingPathComponent(path)
        let httpMethod = HTTPMethod(rawValue: method.rawValue) ?? .get
        
        manager.request(URL, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200...399).responseJSON { response in
            completion?(response.validate())
        }
    }
}

// MARK: - DataResponse

extension DataResponse {
    func validate() -> APIResult<[String: Any]> {
        switch result {
        case .success(let value):
            guard let responseObject = value as? [String: Any] else {
                let error = NSError(type: .invalidResponse)
                return APIResult.failure(error)
            }
            
            if let _ = responseObject[APIConstants.Response.Keys.error] as? String {
                return APIResult.success([:])
            }
            
            guard let success = responseObject[APIConstants.Response.Keys.success] as? Bool else {
                let error = NSError(type: .invalidResponse)
                return APIResult.failure(error)
            }
            
            guard success else {
                let message = responseObject[APIConstants.Response.Keys.message] as? String ?? "Something went wrong..."
                let error = NSError(message: message)
                return APIResult.failure(error)
            }
            
            return APIResult.success(responseObject)
        case .failure(let error):
            return APIResult.failure(error)
        }
    }
}
