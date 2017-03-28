//
//  LoginService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public class LoginService: APIService {

}

// MARK: - Public

public extension LoginService {
    func login(withCredentials credentials: Credentials, completion: ServiceCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.login,
            APIConstants.Request.Keys.username: credentials.username,
            APIConstants.Request.Keys.password: credentials.password
        ]

        client.request(method: .get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseLogin(response: value, completion: completion)
            case .failure(let error):
                completion?(ServiceResult(error: error))
            }
        }
    }

    func logout() {
        Keychain.deleteAllStoredValues()
        User.deleteAll()
    }
}

// MARK: - Private

private extension LoginService {
    func parseLogin(response: [String: Any], completion: ServiceCompletion?) {
        guard let accessToken = response[APIConstants.Response.Keys.userToken] as? String else {
            let error = NSError(type: .invalidAccessToken)
            completion?(ServiceResult(error: error))
            return
        }

        User.user(from: response) { user in
            guard let userID = user?.userID else {
                let error = NSError(type: .importFailure)
                completion?(ServiceResult(error: error))
                return
            }

            Keychain.save(.userID, value: userID.stringValue)
            Keychain.save(.accessToken, value: accessToken)

            completion?(.success)
        }
    }
}
