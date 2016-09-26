//
//  GameListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class GameListDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Game
    
    private(set) var fetchedResultsController: NSFetchedResultsController
    
    let title: String?
    
    dynamic var empty = false
    
    var fetchedChangeHandler: FetchedChangeHandler?
    
    init(pool: Pool) {
        title = pool.name
        fetchedResultsController = Game.fetchedGamesForPool(pool)
        
        super.init()
        
        register(fetchedResultsController: fetchedResultsController)
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    init(cluster: Cluster) {
        title = "Crossovers"
        fetchedResultsController = Game.fetchedGamesForCluster(cluster)
        
        super.init()
        
        register(fetchedResultsController: fetchedResultsController)
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        unregister(fetchedResultsController: fetchedResultsController)
    }
}

// MARK: - Public

extension GameListDataSource {
    func titleAtSection(section: Int) -> String? {
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let game = itemAtIndexPath(indexPath)
        let dateFormatter = DateService.gameStartDateFullFormatter
        
        return game?.startDateFull.flatMap({dateFormatter.stringFromDate($0)})
    }
}
