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
import EZDataSource

class GameSection: Section<GameViewModel> {
    init(viewModels: [GameViewModel]) {
        let headerTitle = viewModels.first?.startDate
        super.init(items: viewModels, headerTitle: headerTitle)
    }
}

class GameListDataSource: NSObject, SectionedDataSource {
    typealias ItemType = GameViewModel
    typealias SectionType = GameSection

    fileprivate(set) var sections = [GameSection]()
    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<Game>

    let title: String?

    dynamic var empty = false

    var reloadBlock: ReloadBlock?
    
    init(viewModel: PoolViewModel) {
        title = viewModel.name
        fetchedResultsController = Game.fetchedGamesForPool(withId: viewModel.poolID)

        super.init()
        
        commonInit()
    }

    init(clusters: [Cluster]) {
        title = "Crossovers"
        fetchedResultsController = Game.fetchedGamesFor(clusters: clusters)

        super.init()

        commonInit()
    }
    
    init(viewModel: StageViewModel) {
        title = viewModel.name
        fetchedResultsController = Game.fetchedGamesForStage(withId: viewModel.stageId)
                
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
            let viewModelsList = fetchedSections.flatMap { $0.objects as? [Game] }.map { $0.map { GameViewModel(game: $0) } }
            let gameSections = viewModelsList.map { GameSection(viewModels: $0) }
            sections.append(contentsOf: gameSections)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GameListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?(.all)
    }
}
