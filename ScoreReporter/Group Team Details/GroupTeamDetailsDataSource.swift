//
//  GroupTeamDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import CoreData
import ScoreReporterCore
import DataSource

class GroupTeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Game
    typealias SectionType = Section<Game>
    
    fileprivate let poolFetchedResultsController: NSFetchedResultsController<ManagedGame>
    fileprivate let crossoverFetchedResultsController: NSFetchedResultsController<ManagedGame>
    fileprivate let bracketFetchedResultsController: NSFetchedResultsController<ManagedGame>
    
    fileprivate(set) var sections = [Section<Game>]()
    
    let group: Group
    let teamName: String
    
    var reloadBlock: ReloadBlock?
    
    dynamic var empty = false
    
    init(group: Group, teamName: String) {
        self.group = group
        self.teamName = teamName
        
        poolFetchedResultsController = ManagedGame.fetchedPoolGames(forGroup: group, teamName: teamName)
        crossoverFetchedResultsController = ManagedGame.fetchedCrossoverGames(forGroup: group, teamName: teamName)
        bracketFetchedResultsController = ManagedGame.fetchedBracketGames(forGroup: group, teamName: teamName)
        
        super.init()
        
        poolFetchedResultsController.delegate = self
        crossoverFetchedResultsController.delegate = self
        bracketFetchedResultsController.delegate = self
        
        configureSections()
    }
    
    deinit {
        poolFetchedResultsController.delegate = nil
        crossoverFetchedResultsController.delegate = nil
        bracketFetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension GroupTeamDetailsDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let managedGames = poolFetchedResultsController.fetchedObjects, !managedGames.isEmpty {
            let games = managedGames.flatMap { Game(game: $0) }
            let section = Section(items: games, headerTitle: games.first?.container.name)
            sections.append(section)
        }
        
        if let managedGames = crossoverFetchedResultsController.fetchedObjects, !managedGames.isEmpty {
            let games = managedGames.flatMap { Game(game: $0) }
            let section = Section(items: games, headerTitle: "Crossovers")
            sections.append(section)
        }
        
        if let managedGames = bracketFetchedResultsController.fetchedObjects, !managedGames.isEmpty {
            let games = managedGames.flatMap { Game(game: $0) }
            let section = Section(items: games, headerTitle: "Bracket Play")
            sections.append(section)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GroupTeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
