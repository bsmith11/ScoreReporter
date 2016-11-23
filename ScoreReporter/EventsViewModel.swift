//
//  MyEventsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class EventsViewModel: NSObject {
    fileprivate let eventService = EventService(client: APIClient.sharedInstance)

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension EventsViewModel {
    func downloadEvents() {
        loading = true

        eventService.downloadEventList { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
