//
//  Group.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

public struct Group {
    public let id: Int
    public let name: String
    public let teamCount: Int
    public let divisionName: String?
    public let division: String?
    public let type: String?
    public let event: Event
    public let rounds: Set<Round>
    
    public let fullName: String
    public let divisionIdentifier: String
    public let divisionColor: UIColor
    
    public init?(group: ManagedGroup) {
        guard let event = group.event.flatMap({ Event(event: $0) }) else {
            return nil
        }
        
        self.id = group.groupID.intValue
        self.name = group.name ?? "No Name"
        self.teamCount = group.teamCount.flatMap { Int($0) } ?? 0
        self.divisionName = group.divisionName
        self.division = group.division
        self.type = group.type
        self.event = event
        
        let managedRounds = group.rounds as? Set<ManagedRound> ?? []
        self.rounds = Set(managedRounds.flatMap { Round(round: $0) })
        
        let strings = [
            group.type,
            group.division,
            group.divisionName
        ]
        
        fullName = strings.flatMap { $0 }.joined(separator: " ")
        
        if let division = group.division {
            switch division {
            case "Men", "Boys":
                divisionIdentifier = "M"
                divisionColor = UIColor.scBlue
            case "Women", "Girls":
                divisionIdentifier = "W"
                divisionColor = UIColor.scRed
            case "Mixed":
                divisionIdentifier = "X"
                divisionColor = UIColor.black
            default:
                divisionIdentifier = "?"
                divisionColor = UIColor.black
            }
        }
        else {
            divisionIdentifier = "?"
            divisionColor = UIColor.black
        }
    }
}

// MARK: - Hashable

extension Group: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}
