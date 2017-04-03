//
//  EventDetailsDataController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class EventDetailsDataController: NSObject {
    fileprivate let dataSource: EventDetailsDataSource
    fileprivate let eventService = EventService()

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil

    init(dataSource: EventDetailsDataSource) {
        self.dataSource = dataSource

        super.init()
    }
}

// MARK: - Public

extension EventDetailsDataController {
    func getEventDetails() {
        loading = true

        eventService.getDetails(forEvent: dataSource.event) { [weak self] result in
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
