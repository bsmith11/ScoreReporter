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
    private let dataSource: EventDetailsDataSource
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let headerView = EventDetailsHeaderView(frame: .zero)
    
    private var favoriteButton: UIBarButtonItem?
    private var unfavoriteButton: UIBarButtonItem?
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: EventDetailsViewModel, dataSource: EventDetailsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Event Details"
        
        let favoriteImage = UIImage(named: "icn-star")
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .Plain, target: self, action: #selector(favoriteButtonTapped))
        
        let unfavoriteImage = UIImage(named: "icn-star-selected")
        unfavoriteButton = UIBarButtonItem(image: unfavoriteImage, style: .Plain, target: self, action: #selector(unfavoriteButtonTapped))
        
        navigationItem.rightBarButtonItem = dataSource.event.bookmarked.boolValue ? unfavoriteButton : favoriteButton
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.downloadEventDetails()
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
        tableView.registerHeaderFooterClass(HomeSectionHeaderView)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let eventViewModel = EventViewModel(event: dataSource.event)
        headerView.configureWithViewModel(eventViewModel)
        headerView.delegate = self
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
    
    @objc func favoriteButtonTapped() {
        navigationItem.setRightBarButtonItem(unfavoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = true
        
        do {
            try event.managedObjectContext?.rzv_saveToStoreAndWait()
        }
        catch(let error) {
            print("Error: \(error)")
        }
    }
    
    @objc func unfavoriteButtonTapped() {
        navigationItem.setRightBarButtonItem(favoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = false
        
        do {
            try event.managedObjectContext?.rzv_saveToStoreAndWait()
        }
        catch(let error) {
            print("Error: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as EventDetailsInfoCell
        let item = dataSource.itemAtIndexPath(indexPath)
        
        cell.configureWithInfo(item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.sectionAtIndex(section)?.title else {
            return nil
        }
        
        let headerView = tableView.dequeueHeaderFooterView() as HomeSectionHeaderView
        
        headerView.configureWithTitle(title)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        switch item {
        case .Address:
            let eventViewModel = EventViewModel(event: dataSource.event)
            
            guard  let coordinate = eventViewModel.coordinate else {
                return
            }
            
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = eventViewModel.name
            
            let options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            mapItem.openInMapsWithLaunchOptions(options)
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case .Date(let date):
            return
        case .Division(let group):
            return
        }
    }
}

// MARK: - EventDetailsHeaderViewDelegate

extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
    func headerViewDidSelectMap(headerView: EventDetailsHeaderView) {
        
    }
}
