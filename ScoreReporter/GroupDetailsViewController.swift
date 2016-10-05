//
//  GroupDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import MapKit

class GroupDetailsViewController: UIViewController, MessageDisplayable {
    private let dataSource: GroupDetailsDataSource
    private let segmentedControlContainerView = UIView(frame: .zero)
    private let segmentedControl = UISegmentedControl(frame: .zero)
    private let contentView = UIView(frame: .zero)
    
    private var currentChildViewController: UIViewController?
    
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
        
        dataSource.refreshBlock = { [weak self] in
            self?.reloadSegmentedControl()
            
            if self?.segmentedControl.numberOfSegments > 0 {
                self?.segmentedControl.selectedSegmentIndex = 0
                self?.segmentedControlValueChanged()
            }
        }
        
        if segmentedControl.numberOfSegments > 0 {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged()
        }
    }
}

// MARK: - Private

private extension GroupDetailsViewController {
    func configureViews() {
        segmentedControlContainerView.backgroundColor = UIColor.USAUNavyColor()
        view.addSubview(segmentedControlContainerView)
        
        reloadSegmentedControl()
        
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), forControlEvents: .ValueChanged)
        segmentedControlContainerView.addSubview(segmentedControl)
        
        view.addSubview(contentView)
    }
    
    func configureLayout() {
        segmentedControlContainerView.topAnchor == topLayoutGuide.bottomAnchor
        segmentedControlContainerView.horizontalAnchors == horizontalAnchors
        
        segmentedControl.edgeAnchors == segmentedControlContainerView.edgeAnchors + 16.0
        
        contentView.topAnchor == segmentedControlContainerView.bottomAnchor
        contentView.horizontalAnchors == horizontalAnchors
        contentView.bottomAnchor == bottomLayoutGuide.topAnchor
    }
    
    func reloadSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        for (index, viewController) in dataSource.items.enumerate() {
            segmentedControl.insertSegmentWithTitle(viewController.title, atIndex: index, animated: false)
        }
    }
    
    @objc func segmentedControlValueChanged() {
        let index = segmentedControl.selectedSegmentIndex
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let item = dataSource.itemAtIndexPath(indexPath)
        
        displayViewController(item)
    }
    
    func displayViewController(viewController: UIViewController?) {
        if let currentChildViewController = currentChildViewController {
            currentChildViewController.willMoveToParentViewController(nil)
            currentChildViewController.view.removeFromSuperview()
            currentChildViewController.removeFromParentViewController()
        }
        
        currentChildViewController = viewController
        
        if let viewController = viewController {
            addChildViewController(viewController)
            contentView.addSubview(viewController.view)
            viewController.view.edgeAnchors == contentView.edgeAnchors
            viewController.didMoveToParentViewController(self)
        }
    }
}
