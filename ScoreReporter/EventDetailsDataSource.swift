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

struct EventDetailsSection {
    let title: String?
    let items: [EventDetailsInfo]
}

enum EventDetailsInfo {
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
        
        calculateCoordinates()
        configureSections()
    }
}

// MARK: - Public

extension EventDetailsDataSource {
    func section(at section: Int) -> EventDetailsSection? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section]
    }
}

// MARK: - Private

private extension EventDetailsDataSource {
    func configureSections() {
        let eventViewModel = EventViewModel(event: event)
        
        sections.removeAll()
        sections.append(EventDetailsSection(title: "Info", items: [
            .address(eventViewModel.address),
            .date(eventViewModel.eventDates)
        ]))
        
        let divisions = eventViewModel.groups.map { EventDetailsInfo.division($0) }
        sections.append(EventDetailsSection(title: "Divisions", items: divisions))
        
        if let activeGames = activeGamesFetchedResultsController.fetchedObjects as? [Game], !activeGames.isEmpty {
            sections.append(EventDetailsSection(title: "Active Games", items: activeGames.map { .activeGame($0) }))
        }
    }
    
    func calculateCoordinates() {
        guard let city = event.city,
            let state = event.state, event.latitude == nil else {
                return
        }
        
        let geocoder = CLGeocoder()
        let addressString = "\(city), \(state)"
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                return
            }
            
            self.event.latitude = coordinate.latitude as NSNumber?
            self.event.longitude = coordinate.longitude as NSNumber?
            
            do {
                try Event.coreDataStack.mainContext.save()
            }
            catch(let error) {
                print("Failed to save with error: \(error)")
            }
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
