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
    typealias ModelType = ManagedGame
    typealias SectionType = Section<ModelType>
    
    fileprivate let poolFetchedResultsController: NSFetchedResultsController<ManagedGame>
    fileprivate let crossoverFetchedResultsController: NSFetchedResultsController<ManagedGame>
    fileprivate let bracketFetchedResultsController: NSFetchedResultsController<ManagedGame>
    
    fileprivate(set) var sections = [Section<ModelType>]()
    
    let group: ManagedGroup
    let teamName: String
    
    var reloadBlock: ReloadBlock?
    
    init(group: ManagedGroup, teamName: String) {
        self.group = group
        self.teamName = teamName
        
        poolFetchedResultsController = ManagedGame.fetchedPoolGamesFor(group: group, teamName: teamName)
        crossoverFetchedResultsController = ManagedGame.fetchedCrossoverGamesFor(group: group, teamName: teamName)
        bracketFetchedResultsController = ManagedGame.fetchedBracketGamesFor(group: group, teamName: teamName)
        
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
        
        if let games = poolFetchedResultsController.fetchedObjects, !games.isEmpty {
            let section = Section(items: games, headerTitle: games.first?.pool?.name)
            sections.append(section)
        }
        
        if let games = crossoverFetchedResultsController.fetchedObjects, !games.isEmpty {
            let section = Section(items: games, headerTitle: "Crossovers")
            sections.append(section)
        }
        
        if let games = bracketFetchedResultsController.fetchedObjects, !games.isEmpty {
            let section = Section(items: games, headerTitle: "Bracket Play")
            sections.append(section)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GroupTeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
