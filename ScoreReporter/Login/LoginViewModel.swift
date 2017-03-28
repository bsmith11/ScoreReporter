//
//  LoginViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

typealias LoginCompletion = (Bool) -> Void

class LoginViewModel: NSObject {
    fileprivate let loginService = LoginService(client: APIClient.sharedInstance)

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension LoginViewModel {
    func login(with credentials: Credentials, completion: LoginCompletion?) {
        loading = true

        loginService.login(withCredentials: credentials) { [weak self] result in
            guard let sself = self else {
                return
            }
            
            sself.loading = false
            
            switch result {
            case .success:
                completion?(true)
            case .failure(let error):
                sself.error = error
                completion?(false)
            }
        }
    }
}
