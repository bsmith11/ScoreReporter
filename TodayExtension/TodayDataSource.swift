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
import EZDataSource

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
        let currentGames = Game.gamesToday(for: team)

        guard let event = currentGames.first?.group?.event else {
            return nil
        }

        self.team = team
        self.event = event
        self.games = currentGames
        
        let items = currentGames.map { TodayItem.game($0) }
        
        super.init(items: items)
    }
}

class TodayEventSection: Section<TodayItem> {
    let team: Team
    let events: [Event]

    init?(team: Team) {
        guard let events = Event.fetchedUpcomingEventsFor(team: team).fetchedObjects, !events.isEmpty else {
            return nil
        }

        self.team = team
        self.events = events
        
        let items = events.map { TodayItem.event($0) }
        let headerTitle = TeamViewModel(team: team).fullName
        
        super.init(items: items, headerTitle: headerTitle)
    }
}

class TodayDataSource: NSObject, SectionedDataSource {
    typealias ItemType = TodayItem
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
        teams = Team.fetchedBookmarkedTeams().fetchedObjects ?? []

        sections = teams.map { TodayEventSection(team: $0) }.flatMap { $0 }
        empty = sections.isEmpty
    }
}
