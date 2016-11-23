//
//  TodayDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore

enum TodayItem {
    case game(Game)
    case event(Event)
}

protocol TodaySection {
    var title: String? { get }
    var items: [TodayItem] { get }
}

struct TodayGameSection: TodaySection {
    let team: Team
    let event: Event
    let games: [Game]
    let items: [TodayItem]
    
    fileprivate(set) var title: String?
    
    init?(team: Team) {
        let currentGames = Game.gamesToday(for: team)
        
        guard let event = currentGames.first?.group?.event else {
            return nil
        }
        
        self.team = team
        self.event = event
        self.games = currentGames
        self.items = currentGames.map { TodayItem.game($0) }
    }
}

struct TodayEventSection: TodaySection {
    let team: Team
    let events: [Event]
    let items: [TodayItem]
    
    fileprivate(set) var title: String?
    
    init?(team: Team) {
        guard let events = Event.fetchedUpcomingEvents(for: team).fetchedObjects, !events.isEmpty else {
            return nil
        }
        
        self.team = team
        self.events = events
        self.items = events.map { TodayItem.event($0) }
    }
}

class TodayDataSource: NSObject {
    fileprivate var sections = [TodaySection]()
    
    fileprivate(set) var empty = false
    fileprivate(set) var team: Team?
    
    override init() {
        super.init()
        
        configureSections()
    }
}

// MARK: - Public

extension TodayDataSource {
    func title(for section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].title
    }
}

// MARK: - Private

private extension TodayDataSource {
    func configureSections() {
        sections.removeAll()
        
        team = Team.fetchedBookmarkedTeams().fetchedObjects?.first
        
        guard let team = team else {
            empty = true
            return
        }
        
        if let section = TodayGameSection(team: team) {
            sections.append(section)
        }
        else if let section = TodayEventSection(team: team) {
            sections.append(section)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - DataSource

extension TodayDataSource: DataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func item(at indexPath: IndexPath) -> TodayItem? {
        guard indexPath.section < sections.count else {
            return nil
        }
        
        let section = sections[indexPath.section]
        
        guard indexPath.item < section.items.count else {
            return nil
        }
        
        return section.items[indexPath.item]
    }
}
