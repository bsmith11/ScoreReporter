//
//  LoginViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

typealias LoginCompletion = NSError? -> Void

struct Credentials {
    let username: String
    let password: String
}

class LoginViewModel: NSObject {
    private let loginService = LoginService(client: APIClient.sharedInstance)
    
    private(set) dynamic var loading = false
    private(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension LoginViewModel {
    func loginWithCredentials(credentials: Credentials, completion: LoginCompletion?) {
        loading = true
        
        loginService.loginWithCredentials(credentials) { [weak self] error in
            self?.loading = false
            self?.error = error
            
            completion?(error)
        }
    }
}
