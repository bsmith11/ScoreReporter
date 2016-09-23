//
//  Group+CoreDataProperties.swift
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

extension Group {

    @NSManaged var division: String?
    @NSManaged var divisionName: String?
    @NSManaged var groupID: NSNumber
    @NSManaged var name: String?
    @NSManaged var teamCount: String?
    @NSManaged var type: String?
    @NSManaged var event: Event?
    @NSManaged var rounds: NSSet

}
