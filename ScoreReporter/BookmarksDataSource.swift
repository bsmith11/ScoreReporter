//
//  BookmarksDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore

class BookmarksDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Event
    
    fileprivate(set) var fetchedResultsController = Event.fetchedBookmarkedEvents()
    
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
