//
//  EventListDataController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class EventListDataController: NSObject {
    fileprivate let dataSource: EventListDataSource
    fileprivate let eventService = EventService()

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
    
    init(dataSource: EventListDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - Public

extension EventListDataController {
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
