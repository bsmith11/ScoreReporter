//
//  LoginService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public struct Credentials {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

public struct LoginService {
    fileprivate let client: APIClient

    public init(client: APIClient) {
        self.client = client
    }
}

// MARK: - Public

public extension LoginService {
    func login(with credentials: Credentials, completion: DownloadCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.login,
            APIConstants.Request.Keys.username: credentials.username,
            APIConstants.Request.Keys.password: credentials.password
        ]

        client.request(.get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseLogin(response: value, completion: completion)
            case .failure(let error):
                completion?(error as NSError)
            }
        }
    }

    func logout() {
        KeychainService.deleteAllStoredValues()
        User.deleteAll()
    }
}

// MARK: - Private

private extension LoginService {
    func parseLogin(response: [String: Any], completion: DownloadCompletion?) {
        guard let accessToken = response[APIConstants.Response.Keys.userToken] as? String else {
            let error = NSError(domain: "No Access Token", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        User.user(from: response) { user in
            guard let userID = user?.userID else {
                let error = NSError(domain: "Failed to parse User", code: 0, userInfo: nil)
                completion?(error)
                return
            }

            KeychainService.save(.userID, value: userID.stringValue)
            KeychainService.save(.accessToken, value: accessToken)

            completion?(nil)
        }
    }
}
