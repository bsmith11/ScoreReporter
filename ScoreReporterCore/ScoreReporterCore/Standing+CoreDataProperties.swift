//
//  Standing+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension Standing {

    @NSManaged var losses: NSNumber?
    @NSManaged var seed: NSNumber?
    @NSManaged var sortOrder: NSNumber?
    @NSManaged var teamName: String?
    @NSManaged var wins: NSNumber?
    @NSManaged var pool: Pool?

}
