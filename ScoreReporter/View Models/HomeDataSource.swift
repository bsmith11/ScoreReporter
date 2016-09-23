//
//  HomeDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class HomeDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Event
    
    private(set) var fetchedResultsController = Event.fetchedEventsThisWeek()
    
    dynamic var empty = false
    
    var fetchedChangeHandler: FetchedChangeHandler?
    
    override init() {
        super.init()
        
        register(fetchedResultsController: fetchedResultsController)
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        unregister(fetchedResultsController: fetchedResultsController)
    }
}

// MARK: - Public

extension HomeDataSource {
    func titleForSection(section: Int) -> String {
        return "This Week"
    }
}