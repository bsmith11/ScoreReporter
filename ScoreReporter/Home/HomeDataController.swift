//
//  HomeDataController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class HomeDataController: NSObject {
    fileprivate let dataSource: HomeDataSource
    fileprivate let eventService = EventService()
    
    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
    
    init(dataSource: HomeDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - Public

extension HomeDataController {
    func getEvents() {
        loading = true

        eventService.getEventList { [weak self] result in
            guard let sself = self else {
                return
            }
            
            sself.loading = false
            
            switch result {
            case .success:
                break
            case .failure(let error):
                sself.error = error
            }
        }
    }
}
