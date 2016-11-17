//
//  TeamDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ScoreReporterCore

struct TeamDetailsSection {
    let title: String?
    let items: [TeamDetailsInfo]
}

enum TeamDetailsInfo {
    case team(Team)
    case event(Event)
    case activeGame(Game)
}

class TeamDetailsDataSource: NSObject {
    fileprivate let activeGamesFetchedResultsController: NSFetchedResultsController<Game>
    
    fileprivate var sections = [TeamDetailsSection]()
    
    let team: Team
    
    var refreshBlock: RefreshBlock?
    
    init(team: Team) {
        self.team = team
        
        activeGamesFetchedResultsController = Game.fetchedActiveGamesForTeam(team)
        
        super.init()
        
        activeGamesFetchedResultsController.delegate = self
        
        configureSections()
    }
    
    deinit {
        activeGamesFetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension TeamDetailsDataSource {
    func title(for section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].title
    }
    
    func refresh() {
        configureSections()
        refreshBlock?()
    }
}

// MARK: - Private

private extension TeamDetailsDataSource {
    func configureSections() {
        sections.removeAll()
        
        sections.append(TeamDetailsSection(title: nil, items: [.team(team)]))
        
        if let groups = team.groups as? Set<Group> {
            let events = groups.flatMap { $0.event }
            let eventItems = events.map { TeamDetailsInfo.event($0) }
            
            if !eventItems.isEmpty {
                sections.append(TeamDetailsSection(title: "Events", items: eventItems))
            }
        }
        
//        let divisions = eventViewModel.groups.map { EventDetailsInfo.division($0) }
//        sections.append(EventDetailsSection(title: "Divisions", items: divisions))
//        
//        if let activeGames = activeGamesFetchedResultsController.fetchedObjects, !activeGames.isEmpty {
//            sections.append(EventDetailsSection(title: "Active Games", items: activeGames.map { .activeGame($0) }))
//        }
    }
}

// MARK: - DataSource

extension TeamDetailsDataSource: DataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func item(at indexPath: IndexPath) -> TeamDetailsInfo? {
        guard indexPath.section < sections.count && indexPath.item < sections[indexPath.section].items.count else {
            return nil
        }
        
        return sections[indexPath.section].items[indexPath.item]
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        refreshBlock?()
    }
}
