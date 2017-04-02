//
//  ManagedGroup+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedGroup {

    @NSManaged var division: String?
    @NSManaged var divisionName: String?
    @NSManaged var groupID: NSNumber
    @NSManaged var name: String?
    @NSManaged var teamCount: String?
    @NSManaged var type: String?
    @NSManaged var event: ManagedEvent?
    @NSManaged var rounds: NSSet
    @NSManaged var teams: NSSet

}
