//
//  SettingsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String?
    let items: [SettingsItem]
}

enum SettingsItem {
    case acknowledgements
    case about
    
    var image: UIImage? {
        switch self {
        case .acknowledgements:
            return nil
        case .about:
            return UIImage(named: "")
        }
    }
    
    var title: String {
        switch self {
        case .acknowledgements:
            return "Acknowledgements"
        case .about:
            return "About"
        }
    }
}

class SettingsDataSource {
    typealias ModelType = SettingsItem
    
    fileprivate var sections = [SettingsSection]()
    
    init() {
        configureSections()
    }
}

// MARK: - Public

extension SettingsDataSource {
    func titleForSection(_ section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].title
    }
}

// MARK: - Private

private extension SettingsDataSource {
    func configureSections() {
        let section = SettingsSection(title: nil, items: [.acknowledgements])
        sections.append(section)
    }
}

// MARK: - DataSource

extension SettingsDataSource: DataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> SettingsItem? {
        guard indexPath.section < sections.count else {
            return nil
        }
        
        let section = sections[indexPath.section]
        
        guard indexPath.item < section.items.count else {
            return nil
        }
        
        return section.items[indexPath.item]
    }
}
