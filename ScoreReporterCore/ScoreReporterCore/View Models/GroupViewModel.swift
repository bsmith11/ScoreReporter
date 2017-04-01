//
//  GroupViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

public struct GroupViewModel {
    public let groupID: Int
//    public let name: String
//    public let teamCount: Int
//    public let divisionName: String?
    
//    public let division: String?
//    public let type: String?
    
//    public let event: Event
//    public let rounds: Set<Round>
//    public let teams: Set<Team>
    
    public let fullName: String
    public let divisionIdentifier: String
    public let divisionColor: UIColor

    public init(group: Group?) {
        self.groupID = group?.groupID.intValue ?? 0
        
        let strings = [
            group?.type,
            group?.division,
            group?.divisionName
        ]

        fullName = strings.flatMap { $0 }.joined(separator: " ")

        if let division = group?.division {
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

extension GroupViewModel: Hashable {
    public var hashValue: Int {
        return groupID
    }
    
    public static func == (lhs: GroupViewModel, rhs: GroupViewModel) -> Bool {
        return lhs.groupID == rhs.groupID
    }
}
