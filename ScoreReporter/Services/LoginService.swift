//
//  LoginService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

struct LoginService {
    let client: APIClient
}

// MARK: - Public

extension LoginService {
    func login(with credentials: Credentials, completion: DownloadCompletion?) {
        let parameters = [
            "f": "MemberLogin",
            "username": credentials.username,
            "password": credentials.password
        ]
        
        let requestCompletion = { (result: Result<Any>) in
            if result.isSuccess {
                self.handleSuccessfulLoginResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error as NSError?)
            }
        }
        
        client.request(.get, path: "", parameters: parameters, completion: requestCompletion)
    }
    
    func logout() {
        KeychainService.deleteAllStoredValues()
        
        //TODO: - Delete all User objects
    }
}

// MARK: - Private

private extension LoginService {
    func handleSuccessfulLoginResponse(_ response: Any?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }
        
        guard let success = responseObject["success"] as? Bool, success else {
            if let message = responseObject["message"] as? String {
                print("Error Message: \(message)")
                completion?(nil)
            }
            else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
            }
            
            return
        }
        
        guard let accessToken = responseObject["UserToken"] as? String else {
            print("Error Message: No Access Token")
            completion?(nil)
            return
        }
        
        User.user(from: responseObject) { user in
            guard let userID = user?.userID else {
                completion?(nil)
                return
            }
            
            KeychainService.save(.userID, value: userID.stringValue)
            KeychainService.save(.accessToken, value: accessToken)
            
            completion?(nil)
        }
    }
}