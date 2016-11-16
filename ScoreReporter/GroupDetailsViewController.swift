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
import ScoreReporterCore

class GroupDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: GroupViewModel
    fileprivate let dataSource: GroupDetailsDataSource
    fileprivate let segmentedControl = SegmentedControl(frame: .zero)
    fileprivate let contentView = UIView(frame: .zero)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var segmentedControlHeight: NSLayoutConstraint?
    fileprivate var currentChildViewController: UIViewController?
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(dataSource: GroupDetailsDataSource) {
        self.dataSource = dataSource
        
        viewModel = GroupViewModel(group: dataSource.group)
        
        super.init(nibName: nil, bundle: nil)
        
        title = viewModel.fullName
        
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
            }
        }
        
        reloadSegmentedControl()
        
        if segmentedControl.numberOfSegments > 0 {
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.navigationController?.navigationBar.barTintColor = self?.viewModel.divisionColor
        }, completion: nil)
    }
}

// MARK: - Private

private extension GroupDetailsViewController {
    func configureViews() {
        segmentedControl.setTitleColor(viewModel.divisionColor, for: .selected)
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)
        
        view.addSubview(contentView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = "No Schedule Available"
        let emptyMessage = "No pools, crossovers, or brackets have been created for this event"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        segmentedControl.topAnchor == topLayoutGuide.bottomAnchor
        segmentedControl.horizontalAnchors == horizontalAnchors
        segmentedControlHeight = segmentedControl.heightAnchor == 0.0
        segmentedControlHeight?.isActive = false
        
        contentView.topAnchor == segmentedControl.bottomAnchor
        contentView.horizontalAnchors == horizontalAnchors
        contentView.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == contentView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
            self?.segmentedControlHeight?.isActive = empty
        }
    }
    
    func reloadSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        for (index, viewController) in dataSource.items.enumerated() {
            segmentedControl.insertSegment(withTitle: viewController.title, at: index, animated: false)
        }
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

// MARK: - SegmentedControlDelegate

extension GroupDetailsViewController: SegmentedControlDelegate {
    func segmentedControlDidSelect(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let item = dataSource.item(at: indexPath)
        
        displayViewController(item)
    }
}
