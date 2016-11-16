//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import NotificationCenter
import ScoreReporterCore
import Anchorage
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    fileprivate let infoView = SearchInfoView(frame: .zero)
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Event.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let context = Event.coreDataStack.mainContext
        
        do {
            let events = try context.fetch(fetchRequest)
            print(events)
        }
        catch let error {
            print("Failed to fetch events")
        }
        
//        let event = Event.fetchedEventsThisWeek().fetchedObjects?.first as? Event
//        infoView.configure(with: event)
    }
    
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//        
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//        
//        completionHandler(NCUpdateResult.newData)
//    }
}

// MARK: - Private

private extension TodayViewController {
    func configureViews() {
        view.addSubview(infoView)
    }
    
    func configureLayout() {
        infoView.edgeAnchors == view.edgeAnchors
    }
}
