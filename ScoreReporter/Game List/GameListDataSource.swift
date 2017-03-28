//
//  GameListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore

class GameListDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Game

    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<Game>

    let title: String?

    dynamic var empty = false

    var fetchedChangeHandler: FetchedChangeHandler?

    init(pool: Pool) {
        title = pool.name
        fetchedResultsController = Game.fetchedGamesFor(pool: pool)

        super.init()

        register(fetchedResultsController: fetchedResultsController)
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }

    init(clusters: [Cluster]) {
        title = "Crossovers"
        fetchedResultsController = Game.fetchedGamesFor(clusters: clusters)

        super.init()

        register(fetchedResultsController: fetchedResultsController)
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    init(stage: Stage) {
        title = stage.name
        fetchedResultsController = Game.fetchedGamesFor(stage: stage)
                
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
    func title(for section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        let game = item(at: indexPath)
        let dateFormatter = DateFormatter.gameStartDateFullFormatter

        return game?.startDateFull.flatMap { dateFormatter.string(from: $0) }
    }
}
