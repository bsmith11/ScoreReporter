//
//  Team+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

public extension Team {
    
    @NSManaged var city: String?
    @NSManaged var competitionLevel: String?
    @NSManaged var designation: String?
    @NSManaged var division: String?
    @NSManaged var logoPath: String?
    @NSManaged var name: String?
    @NSManaged var school: String?
    @NSManaged var state: String?
    @NSManaged var stateFull: String?
    @NSManaged var teamID: NSNumber
    
}
