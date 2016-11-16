//
//  EventDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import CoreData
import ScoreReporterCore

struct EventDetailsSection {
    let title: String?
    let items: [EventDetailsInfo]
}

enum EventDetailsInfo {
    case event(Event)
    case address(String)
    case date(String)
    case division(Group)
    case activeGame(Game)
    
    var image: UIImage? {
        switch self {
        case .address:
            return UIImage(named: "icn-map")
        case .date:
            return UIImage(named: "icn-calendar")
        case .division:
            return nil
        default:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .address(let address):
            return address
        case .date(let date):
            return date
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            return groupViewModel.fullName
        default:
            return ""
        }
    }
}

class EventDetailsDataSource: NSObject {
    fileprivate let activeGamesFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    fileprivate var sections = [EventDetailsSection]()
    
    let event: Event
    
    var refreshBlock: RefreshBlock?
    
    init(event: Event) {
        self.event = event
        
        activeGamesFetchedResultsController = Game.fetchedActiveGamesForEvent(event)
        
        super.init()
        
        configureSections()
    }
}

// MARK: - Public

extension EventDetailsDataSource {
    func title(for section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].title
    }
}

// MARK: - Private

private extension EventDetailsDataSource {
    func configureSections() {
        let eventViewModel = EventViewModel(event: event)
        
        sections.removeAll()
        
        sections.append(EventDetailsSection(title: nil, items: [.event(event)]))
        
//        sections.append(EventDetailsSection(title: "Info", items: [
//            .address(eventViewModel.address),
//            .date(eventViewModel.eventDates)
//        ]))
        
        let divisions = eventViewModel.groups.map { EventDetailsInfo.division($0) }
        sections.append(EventDetailsSection(title: "Divisions", items: divisions))
        
        if let activeGames = activeGamesFetchedResultsController.fetchedObjects as? [Game], !activeGames.isEmpty {
            sections.append(EventDetailsSection(title: "Active Games", items: activeGames.map { .activeGame($0) }))
        }
    }
}

// MARK: - DataSource

extension EventDetailsDataSource: DataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func item(at indexPath: IndexPath) -> EventDetailsInfo? {
        guard indexPath.section < sections.count && indexPath.item < sections[indexPath.section].items.count else {
            return nil
        }
        
        return sections[indexPath.section].items[indexPath.item]
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        refreshBlock?()
    }
}
