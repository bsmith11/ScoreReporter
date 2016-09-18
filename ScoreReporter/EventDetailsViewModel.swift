//
//  EventDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum EventDetailsInfoType {
    case Address(String)
    case Date(String)
    
    var image: UIImage? {
        switch self {
        case .Address:
            return UIImage(named: "icn-map")
        case .Date:
            return UIImage(named: "icn-calendar")
        }
    }
    
    var title: String {
        switch self {
        case .Address(let address):
            return address
        case .Date(let date):
            return date
        }
    }
}

struct EventDetailsViewModel: ArrayDataSource {
    typealias ModelType = EventDetailsInfoType
    
    let event: Event
    
    private(set) var items = [EventDetailsInfoType]()
    
    init(event: Event) {
        self.event = event
        
        calculateCoordinates()
        
        let eventViewModel = EventViewModel(event: event)
        items = [
            .Address(eventViewModel.address),
            .Date(eventViewModel.eventDate)
        ]
    }
}

// MARK: - Private

private extension EventDetailsViewModel {
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
