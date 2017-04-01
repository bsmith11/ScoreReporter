//
//  DeepLinkCoordinator.swift
//  ScoreReporter
//
//  Created by Brad Smith on 3/31/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore

class DeepLinkCoordinator {
    fileprivate let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - Public

extension DeepLinkCoordinator {
    func handle(url: URL) {
        guard let host = url.host else {
            print("Invalid URL: No host")
            return
        }
        
        guard let tabBarController = rootViewController as? TabBarController else {
            print("Invalid view heirarchy")
            return
        }
        
        switch host {
        case "events":
            guard let eventID = url.pathComponents.last.flatMap({ Int($0) }),
                let event = Event.object(primaryKey: NSNumber(value: eventID), context: Event.coreDataStack.mainContext),
                let navigationController = tabBarController.selectedViewController as? UINavigationController else {
                    return
            }
            
            let viewModel = EventViewModel(event: event)
            let dataSource = EventDetailsDataSource(viewModel: viewModel)
            let viewController = EventDetailsViewController(dataSource: dataSource)
            
            navigationController.pushViewController(viewController, animated: false)
        case "games":
            break
        default:
            print("Invalid URL: Unknown host \(host)")
            break
        }
    }
}
