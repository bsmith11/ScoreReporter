//
//  BracketListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/26/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class BracketListDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Bracket
    
    private(set) var fetchedResultsController: NSFetchedResultsController
    
    dynamic var empty = false
    
    var fetchedChangeHandler: FetchedChangeHandler?
    
    init(group: Group) {
        fetchedResultsController = Bracket.fetchedBracketsForGroup(group)
        
        super.init()
        
        register(fetchedResultsController: fetchedResultsController)
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        unregister(fetchedResultsController: fetchedResultsController)
    }
}
