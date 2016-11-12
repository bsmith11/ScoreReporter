//
//  GroupDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class GroupDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let dataSource: GroupDetailsDataSource
    fileprivate let segmentedControlContainerView = UIView(frame: .zero)
    fileprivate let segmentedControl = UISegmentedControl(frame: .zero)
    fileprivate let contentView = UIView(frame: .zero)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var segmentedControlContainerViewHeight: NSLayoutConstraint?
    fileprivate var currentChildViewController: UIViewController?
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(dataSource: GroupDetailsDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        let groupViewModel = GroupViewModel(group: dataSource.group)
        title = groupViewModel.fullName
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
        
        configureObservers()
        
        dataSource.refreshBlock = { [weak self] in
            self?.reloadSegmentedControl()
            
            if self?.segmentedControl.numberOfSegments ?? 0 > 0 {
                self?.segmentedControl.selectedSegmentIndex = 0
                self?.segmentedControlValueChanged()
            }
        }
        
        reloadSegmentedControl()
        
        if segmentedControl.numberOfSegments > 0 {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
}

// MARK: - Private

private extension GroupDetailsViewController {
    func configureViews() {
        segmentedControlContainerView.backgroundColor = UIColor.USAUNavyColor()
        view.addSubview(segmentedControlContainerView)
        
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControlContainerView.addSubview(segmentedControl)
        
        view.addSubview(contentView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = "No Schedule Available"
        let emptyMessage = "No pools, crossovers, or brackets have been created for this event"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        segmentedControlContainerView.topAnchor == topLayoutGuide.bottomAnchor
        segmentedControlContainerView.horizontalAnchors == horizontalAnchors
        segmentedControlContainerViewHeight = segmentedControlContainerView.heightAnchor == 0.0
        segmentedControlContainerViewHeight?.isActive = false
        
        segmentedControl.edgeAnchors == (segmentedControlContainerView.edgeAnchors + 16.0) ~ UILayoutPriorityDefaultHigh
        
        contentView.topAnchor == segmentedControlContainerView.bottomAnchor
        contentView.horizontalAnchors == horizontalAnchors
        contentView.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == contentView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
            self?.segmentedControlContainerViewHeight?.isActive = empty
        }
    }
    
    func reloadSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        for (index, viewController) in dataSource.items.enumerated() {
            segmentedControl.insertSegment(withTitle: viewController.title, at: index, animated: false)
        }
    }
    
    @objc func segmentedControlValueChanged() {
        let index = segmentedControl.selectedSegmentIndex
        let indexPath = IndexPath(row: index, section: 0)
        let item = dataSource.itemAtIndexPath(indexPath)
        
        displayViewController(item)
    }
    
    func displayViewController(_ viewController: UIViewController?) {
        if let currentChildViewController = currentChildViewController {
            currentChildViewController.willMove(toParentViewController: nil)
            currentChildViewController.view.removeFromSuperview()
            currentChildViewController.removeFromParentViewController()
        }
        
        currentChildViewController = viewController
        
        if let viewController = viewController {
            addChildViewController(viewController)
            contentView.addSubview(viewController.view)
            viewController.view.edgeAnchors == contentView.edgeAnchors
            viewController.didMove(toParentViewController: self)
        }
    }
}
