//
//  GroupViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

struct GroupViewModel {
    let fullName: String
    
    init(group: Group?) {
        let strings = [
            group?.type,
            group?.division,
            group?.divisionName
        ]
        
        fullName = strings.flatMap({($0)}).joinWithSeparator(" ")
    }
}
