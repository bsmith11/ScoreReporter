//
//  EventDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class EventDetailsViewModel: NSObject {
    fileprivate let event: Event
    fileprivate let eventService = EventService()

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil

    init(event: Event) {
        self.event = event

        super.init()
    }
}

// MARK: - Public

extension EventDetailsViewModel {
    func downloadEventDetails() {
        loading = true

        eventService.downloadDetails(for: event) { [weak self] result in
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
