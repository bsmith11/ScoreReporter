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

struct EventDetailsSection {
    let title: String?
    let items: [EventDetailsInfo]
}

enum EventDetailsInfo {
    case Address(String)
    case Date(String)
    case Division(Group)
    
    var image: UIImage? {
        switch self {
        case .Address:
            return UIImage(named: "icn-map")
        case .Date:
            return UIImage(named: "icn-calendar")
        case .Division:
            return nil
        }
    }
    
    var title: String {
        switch self {
        case .Address(let address):
            return address
        case .Date(let date):
            return date
        case .Division(let group):
            let groupViewModel = GroupViewModel(group: group)
            return groupViewModel.fullName
        }
    }
}

class EventDetailsDataSource {
    private var sections = [EventDetailsSection]()
    
    let event: Event
    
    init(event: Event) {
        self.event = event
        
        calculateCoordinates()
        configureSections()
    }
}

// MARK: - Public

extension EventDetailsDataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func sectionAtIndex(section: Int) -> EventDetailsSection? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section]
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> EventDetailsInfo? {
        guard indexPath.section < sections.count && indexPath.item < sections[indexPath.section].items.count else {
            return nil
        }
        
        return sections[indexPath.section].items[indexPath.item]
    }
}

// MARK: - Private

private extension EventDetailsDataSource {
    func configureSections() {
        let eventViewModel = EventViewModel(event: event)
        
        sections.removeAll()
        sections.append(EventDetailsSection(title: "Info", items: [
            .Address(eventViewModel.address),
            .Date(eventViewModel.eventDates)
            ]))
        
        let divisions = eventViewModel.groups.map({EventDetailsInfo.Division($0)})
        sections.append(EventDetailsSection(title: "Divisions", items: divisions))
    }
    
    func calculateCoordinates() {
        guard let city = event.city,
            state = event.state where event.latitude == nil else {
                return
        }
        
        let geocoder = CLGeocoder()
        let addressString = "\(city), \(state)"
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard let coordinate = placemarks?.first?.location?.coordinate else {
                return
            }
            
            self.event.latitude = coordinate.latitude
            self.event.longitude = coordinate.longitude
            
            do {
                try Event.rzv_coreDataStack().mainManagedObjectContext.rzv_saveToStoreAndWait()
            }
            catch (let error) {
                print("Failed to save with error: \(error)")
            }
        }
    }
}