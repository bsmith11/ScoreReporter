//
//  APIClient.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public typealias APICompletion = (Result<[String: Any]>) -> Void

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
    func request(_ method: HTTPMethod, path: String, encoding: ParameterEncoding = URLEncoding.default, parameters: [String: Any]? = nil, completion: APICompletion?) {
        let URL = baseURL.appendingPathComponent(path)

        manager.request(URL, method: method, parameters: parameters, encoding: encoding, headers: nil).validate(statusCode: 200...399).responseJSON { response in
            completion?(response.validate())
        }
    }
}

extension DataResponse {
    func validate() -> Result<[String: Any]> {
        switch result {
        case .success(let value):
            guard let responseObject = value as? [String: Any] else {
                let error = NSError(type: .invalidResponse)
                return Result.failure(error)
            }
            
            if let error = responseObject[APIConstants.Response.Keys.error] as? String {
                return Result.success([:])
            }
            
            guard let success = responseObject[APIConstants.Response.Keys.success] as? Bool else {
                let error = NSError(type: .invalidResponse)
                return Result.failure(error)
            }
            
            guard success else {
                let message = responseObject[APIConstants.Response.Keys.message] as? String ?? "Something went wrong..."
                let error = NSError(message: message)
                return Result.failure(error)
            }
            
            return Result.success(responseObject)
        case .failure(let error):
            return Result.failure(error)
        }
    }
}
