//
//  Event+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var bookmarked: NSNumber
    @NSManaged var city: String?
    @NSManaged var endDate: NSDate?
    @NSManaged var eventID: NSNumber
    @NSManaged var latitude: NSNumber?
    @NSManaged var logoPath: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var state: String?
    @NSManaged var type: String?
    @NSManaged var typeName: String?
    @NSManaged var groups: NSSet

}
