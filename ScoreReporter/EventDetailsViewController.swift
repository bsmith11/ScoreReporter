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
import KVOController

class EventDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: EventDetailsViewModel
    fileprivate let dataSource: EventDetailsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let headerView = EventDetailsHeaderView(frame: .zero)
    
    fileprivate var favoriteButton: UIBarButtonItem?
    fileprivate var unfavoriteButton: UIBarButtonItem?
    
    fileprivate var viewDidAppear = false
    
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
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        
        let unfavoriteImage = UIImage(named: "icn-star-selected")
        unfavoriteButton = UIBarButtonItem(image: unfavoriteImage, style: .plain, target: self, action: #selector(unfavoriteButtonTapped))
        
        navigationItem.rightBarButtonItem = dataSource.event.bookmarked.boolValue ? unfavoriteButton : favoriteButton
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.downloadEventDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
        
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.headerView.eventInfoHidden = false
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewDidAppear {
            viewDidAppear = true
            
            configureObservers()
        }
    }
}

// MARK: - Private

private extension EventDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(EventDetailsInfoCell.self)
        tableView.registerClass(GameListCell.self)
        tableView.registerHeaderFooterClass(SectionHeaderView.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let eventViewModel = EventViewModel(event: dataSource.event)
        headerView.configureWithViewModel(eventViewModel)
        headerView.delegate = self
        headerView.eventInfoHidden = true
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(viewModel, keyPath: "loading") { [weak self] (loading: Bool) in
            if loading {
                self?.displayMessage("Loading...", animated: true)
            }
            else {
                self?.hideMessageAnimated(true)
            }
        }
        
        kvoController.observe(viewModel, keyPath: "error") { [weak self] (error: NSError) in
            self?.displayMessage("Error", animated: true)
        }
    }
    
    @objc func favoriteButtonTapped() {
        navigationItem.setRightBarButton(unfavoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = true
        
        do {
            try event.managedObjectContext?.save()
        }
        catch(let error) {
            print("Error: \(error)")
        }
    }
    
    @objc func unfavoriteButtonTapped() {
        navigationItem.setRightBarButton(favoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = false
        
        do {
            try event.managedObjectContext?.save()
        }
        catch(let error) {
            print("Error: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.itemAtIndexPath(indexPath)!
        
        switch item {
        case .activeGame(let game):
            let cell = tableView.dequeueCellForIndexPath(indexPath) as GameListCell
            let gameViewModel = GameViewModel(game: game)
            cell.configureWithViewModel(gameViewModel)
            return cell
        default:
            let cell = tableView.dequeueCellForIndexPath(indexPath) as EventDetailsInfoCell
            cell.configureWithInfo(item)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.sectionAtIndex(section)?.title else {
            return nil
        }
        
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        
        headerView.configureWithTitle(title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        switch item {
        case .address:
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
            mapItem.openInMaps(launchOptions: options)
            
            tableView.deselectRow(at: indexPath, animated: true)
        case .date:
            break
        case .division(let group):
            let groupDetailsDataSource = GroupDetailsDataSource(group: group)
            let groupDetailsViewController = GroupDetailsViewController(dataSource: groupDetailsDataSource)
            
            navigationController?.pushViewController(groupDetailsViewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - EventDetailsHeaderViewDelegate

extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
    func headerViewDidSelectMap(_ headerView: EventDetailsHeaderView) {
        
    }
}
