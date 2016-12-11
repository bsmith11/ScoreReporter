//
//  GroupTeamDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ScoreReporterCore

class GroupTeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Game
    
    fileprivate let poolFetchedResultsController: NSFetchedResultsController<Game>
    fileprivate let crossoverFetchedResultsController: NSFetchedResultsController<Game>
    fileprivate let bracketFetchedResultsController: NSFetchedResultsController<Game>
    
    fileprivate(set) var sections = [DataSourceSection<Game>]()
    
    let group: Group
    let teamName: String
    
    var refreshBlock: RefreshBlock?
    
    init(group: Group, teamName: String) {
        self.group = group
        self.teamName = teamName
        
        poolFetchedResultsController = Game.fetchedPoolGamesFor(group: group, teamName: teamName)
        crossoverFetchedResultsController = Game.fetchedCrossoverGamesFor(group: group, teamName: teamName)
        bracketFetchedResultsController = Game.fetchedBracketGamesFor(group: group, teamName: teamName)
        
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
            let section = DataSourceSection(items: games, headerTitle: games.first?.pool?.name)
            sections.append(section)
        }
        
        if let games = crossoverFetchedResultsController.fetchedObjects, !games.isEmpty {
            let section = DataSourceSection(items: games, headerTitle: "Crossovers")
            sections.append(section)
        }
        
        if let games = bracketFetchedResultsController.fetchedObjects, !games.isEmpty {
            let section = DataSourceSection(items: games, headerTitle: "Bracket Play")
            sections.append(section)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GroupTeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        refreshBlock?()
    }
}
