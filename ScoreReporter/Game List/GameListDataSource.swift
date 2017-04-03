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
import DataSource

class GameSection: Section<Game> {
    init(games: [Game]) {
        //TODO: - Fix this
//        let headerTitle = games.first?.startDate
        super.init(items: games, headerTitle: nil)
    }
}

class GameListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Game
    typealias SectionType = GameSection

    fileprivate(set) var sections = [GameSection]()
    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<ManagedGame>

    let title: String?

    dynamic var empty = false

    var reloadBlock: ReloadBlock?
    
    init(pool: Pool) {
        title = pool.name
        fetchedResultsController = ManagedGame.fetchedGames(forPool: pool)

        super.init()
        
        commonInit()
    }

    init(clusters: [Cluster]) {
        title = "Crossovers"
        fetchedResultsController = ManagedGame.fetchedGames(forClusters: clusters)

        super.init()

        commonInit()
    }
    
    init(stage: Stage) {
        title = stage.name
        fetchedResultsController = ManagedGame.fetchedGames(forStage: stage)
                
        super.init()
        
        commonInit()
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension GameListDataSource {
    func commonInit() {
        fetchedResultsController.delegate = self
        configureSections()
    }
    
    func configureSections() {
        sections.removeAll()
        
        if let fetchedSections = fetchedResultsController.sections {
            let gamesList = fetchedSections.flatMap { $0.objects as? [ManagedGame] }.map { $0.flatMap { Game(game: $0) } }
            let gameSections = gamesList.map { GameSection(games: $0) }
            sections.append(contentsOf: gameSections)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GameListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
