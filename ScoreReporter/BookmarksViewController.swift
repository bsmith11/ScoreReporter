//
//  BookmarksViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class BookmarksViewController: UIViewController, MessageDisplayable {
    fileprivate let dataSource: BookmarksDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var selectedCell: UITableViewCell?
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(dataSource: BookmarksDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Bookmarks"
        
        let image = UIImage(named: "icn-star")
        let selectedImage = UIImage(named: "icn-star-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0.0, bottom: -5.5, right: 0.0)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.tableView.handle(changes: changes)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.selectedCell?.isHidden = false
        })
    }
}

// MARK: - Private

private extension BookmarksViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: EventCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-star-large")
        let emptyTitle = "No Events"
        let emptyMessage = "Bookmark events for easy access"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension BookmarksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as EventCell
        cell.configure(with: event)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = dataSource.item(at: indexPath) else {
            return
        }
        
        selectedCell = tableView.cellForRow(at: indexPath)
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

// MARK: - ListDetailAnimationControllerDelegate

extension BookmarksViewController: ListDetailAnimationControllerDelegate {
    var viewToAnimate: UIView {
        guard let cell = selectedCell as? EventCell,
              let navView = navigationController?.view,
              let snapshot = cell.snapshot(rect: cell.contentFrame) else {
            return UIView()
        }
        
        let frame = cell.contentFrameFrom(view: navView)
        snapshot.frame = frame
        
        cell.isHidden = true
        
        return snapshot
    }
}
