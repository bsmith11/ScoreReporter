//
//  SettingsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import DataSource

enum SettingsItem {
    case acknowledgements
    case help
    case about

    var image: UIImage? {
        switch self {
        case .acknowledgements:
            return nil
        case .help:
            return nil
        case .about:
            return UIImage(named: "icn-about")
        }
    }

    var title: String {
        switch self {
        case .acknowledgements:
            return "Acknowledgements"
        case .help:
            return "Help"
        case .about:
            return "About"
        }
    }
}

class SettingsDataSource: SectionedDataSource {
    typealias ModelType = SettingsItem
    typealias SectionType = Section<ModelType>

    fileprivate(set) var sections = [Section<ModelType>]()

    var reloadBlock: ReloadBlock?
    
    init() {
        configureSections()
    }
}

// MARK: - Private

private extension SettingsDataSource {
    func configureSections() {
        let items: [SettingsItem] = [
            .acknowledgements,
            .help,
            .about
        ]
        
        sections.append(Section(items: items))
    }
}
