//
//  HomeViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

class HomeViewModel: NSObject, FetchedDataSource {
    typealias ModelType = Event
    
    private let eventService = EventService(client: APIClient.sharedInstance)
    private let fetchedChangeService = FetchedChangeService()
    
    private(set) var fetchedResultsController = Event.fetchedEventsThisWeek()
    
    private(set) dynamic var empty = false
    private(set) dynamic var loading = false
    private(set) dynamic var error: NSError? = nil
    
    var changeHandler: ChangeHandler? {
        get {
            return fetchedChangeService.changeHandler
        }
        
        set {
            fetchedChangeService.changeHandler = newValue
        }
    }
    
    override init() {
        super.init()
        
        fetchedResultsController.delegate = fetchedChangeService
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension HomeViewModel {
    func titleForSection(section: Int) -> String {
        return "This Week"
    }
    
    func downloadEvents() {
        loading = true
        
        eventService.downloadEventListWithCompletion { [weak self] error in
            self?.empty = self?.fetchedResultsController.fetchedObjects?.isEmpty ?? true
            self?.loading = false
            self?.error = error
        }
    }
}
