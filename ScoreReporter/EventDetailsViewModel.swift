//
//  EventDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

class EventDetailsViewModel: NSObject {
    fileprivate let event: Event
    fileprivate let eventService = EventService(client: APIClient.sharedInstance)
    
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
        
        eventService.downloadDetailsForEvent(event) { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
