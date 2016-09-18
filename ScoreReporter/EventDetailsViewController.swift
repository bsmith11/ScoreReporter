//
//  EventDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import MapKit

class EventDetailsViewController: UIViewController, MessageDisplayable {
    private let viewModel: EventDetailsViewModel
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let headerView = EventDetailsHeaderView(frame: .zero)
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Event Details"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        configureViews()
        configureLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = headerView.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
}

// MARK: - Private

private extension EventDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(EventDetailsInfoCell)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let eventViewModel = EventViewModel(event: viewModel.event)
        headerView.configureWithViewModel(eventViewModel)
        headerView.delegate = self
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
}

// MARK: - UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as EventDetailsInfoCell
        let item = viewModel.itemAtIndexPath(indexPath)
        
        cell.configureWithType(item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = viewModel.itemAtIndexPath(indexPath) else {
            return
        }
        
        switch item {
        case .Address(let address):
            let eventViewModel = EventViewModel(event: viewModel.event)
            
            guard  let coordinate = eventViewModel.coordinate else {
                return
            }
            
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = eventViewModel.name
            mapItem.openInMapsWithLaunchOptions(nil)
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case .Date(let date):
            return
        }
    }
}

// MARK: - EventDetailsHeaderViewDelegate

extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
    func headerViewDidSelectMap(headerView: EventDetailsHeaderView) {
        
    }
}
