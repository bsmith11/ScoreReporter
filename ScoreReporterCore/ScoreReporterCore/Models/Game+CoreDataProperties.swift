//
//  Game+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension Game {

    @NSManaged var awayTeamName: String?
    @NSManaged var awayTeamSeed: String?
    @NSManaged var awayTeamScore: String?
    @NSManaged var fieldName: String?
    @NSManaged var gameID: NSNumber
    @NSManaged var homeTeamName: String?
    @NSManaged var homeTeamSeed: String?
    @NSManaged var homeTeamScore: String?
    @NSManaged var sortOrder: NSNumber?
    @NSManaged var startDate: Date?
    @NSManaged var startDateFull: Date?
    @NSManaged var startTime: Date?
    @NSManaged var status: String?
    @NSManaged var cluster: Cluster?
    @NSManaged var pool: Pool?
    @NSManaged var stage: Stage?
    @NSManaged var homeTeam: Team?
    @NSManaged var awayTeam: Team?

}
