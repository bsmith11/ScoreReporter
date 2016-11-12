//
//  LoginViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

typealias LoginCompletion = (NSError?) -> Void

struct Credentials {
    let username: String
    let password: String
}

class LoginViewModel: NSObject {
    fileprivate let loginService = LoginService(client: APIClient.sharedInstance)
    
    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension LoginViewModel {
    func login(with credentials: Credentials, completion: LoginCompletion?) {
        loading = true
        
        loginService.login(with: credentials) { [weak self] error in
            self?.loading = false
            self?.error = error
            
            completion?(error)
        }
    }
}
