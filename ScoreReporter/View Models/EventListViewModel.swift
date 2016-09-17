//
//  EventListViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

class EventListViewModel: FetchedDataSource {
    typealias ModelType = Event

    private let eventService = EventService(client: APIClient.sharedInstance)
    private let fetchedChangeService = FetchedChangeService()

    private(set) var fetchedResultsController = Event.fetchedEvents()

    var changeHandler: ChangeHandler? {
        get {
            return fetchedChangeService.changeHandler
        }

        set {
            fetchedChangeService.changeHandler = newValue
        }
    }

    init() {
        fetchedResultsController.delegate = fetchedChangeService
        eventService.downloadEventListWithCompletion(nil)
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}
