//
//  HomeViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    private let eventService = EventService(client: APIClient.sharedInstance)
    
    private(set) dynamic var loading = false
    private(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension HomeViewModel {
    func downloadEvents() {
        loading = true
        
        eventService.downloadEventListWithCompletion { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
