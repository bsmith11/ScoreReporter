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
import DataSource

enum TodayItem {
    case game(Game)
    case event(Event)
}

class TodayGameSection: Section<TodayItem> {
    let team: Team
    let event: Event
    let games: [Game]

    fileprivate(set) var title: String?

    init?(team: Team) {
        let games = ManagedGame.gamesToday(forTeam: team)

        guard let event = games.first?.container.group.event else {
            return nil
        }

        self.team = team
        self.event = event
        self.games = games
        
        let items = games.map { TodayItem.game($0) }
        
        super.init(items: items)
    }
}

class TodayEventSection: Section<TodayItem> {
    let team: Team
    let events: [Event]

    init?(team: Team) {
        guard let managedEvents = ManagedEvent.fetchedUpcomingEvents(forTeam: team).fetchedObjects, !managedEvents.isEmpty else {
            return nil
        }

        self.team = team
        self.events = managedEvents.map { Event(event: $0) }
        
        let items = events.map { TodayItem.event($0) }
        
        super.init(items: items, headerTitle: team.fullName)
    }
}

class TodayDataSource: NSObject, SectionedDataSource {
    typealias ModelType = TodayItem
    typealias SectionType = TodayEventSection
    
    fileprivate(set) var sections = [TodayEventSection]()

    fileprivate(set) var empty = false
    fileprivate(set) var teams = [Team]()
    
    var reloadBlock: ReloadBlock?

    override init() {
        super.init()
        
        configureSections()
    }
}

// MARK: - Private

private extension TodayDataSource {
    func configureSections() {
        let managedTeams = ManagedTeam.fetchedBookmarkedTeams().fetchedObjects ?? []
        teams = managedTeams.flatMap { Team(team: $0) }

        sections = teams.map { TodayEventSection(team: $0) }.flatMap { $0 }
        empty = sections.isEmpty
    }
}
