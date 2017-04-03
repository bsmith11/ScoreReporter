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
    fileprivate let dataSource: GroupDetailsDataSource
    fileprivate let segmentedControl = SegmentedControl(frame: .zero)
    fileprivate let contentView = UIView(frame: .zero)
    fileprivate let emptyView = EmptyView(frame: .zero)

    fileprivate var segmentedControlHeight: NSLayoutConstraint?
    fileprivate var currentChildViewController: UIViewController?

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(dataSource: GroupDetailsDataSource) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = dataSource.group.fullName

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
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

        dataSource.reloadBlock = { [weak self] _ in
            self?.reloadSegmentedControl()
        }

        reloadSegmentedControl()

        if segmentedControl.numberOfSegments > 0 {
            segmentedControl.selectedIndex = 0
        }
    }
}

// MARK: - Private

private extension GroupDetailsViewController {
    func configureViews() {
        segmentedControl.tintColor = UIColor.scBlue
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)

        view.addSubview(emptyView)
        
        let image = UIImage(named: "icn-search")
        let title = "No Schedule Available"
        let message = "No pools, crossovers, or brackets have been created for this event"
        let emptyContentView = EmptyContentView(frame: .zero)
        emptyContentView.configure(withImage: image, title: title, message: message)
        emptyView.set(contentView: emptyContentView, forState: .empty)
        
        view.addSubview(contentView)
    }

    func configureLayout() {
        segmentedControl.topAnchor == topLayoutGuide.bottomAnchor
        segmentedControl.horizontalAnchors == horizontalAnchors
        segmentedControlHeight = segmentedControl.heightAnchor == 0.0
        segmentedControlHeight?.isActive = false

        contentView.topAnchor == segmentedControl.bottomAnchor
        contentView.horizontalAnchors == horizontalAnchors
        contentView.bottomAnchor == bottomLayoutGuide.topAnchor
        
        emptyView.edgeAnchors == contentView.edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(dataSource, keyPath: #keyPath(GroupDetailsDataSource.empty)) { [weak self] (empty: Bool) in
            self?.emptyView.state = empty ? .empty : .none
            self?.segmentedControlHeight?.isActive = empty
        }
    }

    func reloadSegmentedControl() {
        let titles = dataSource.items.map { $0.title }
        segmentedControl.setSegments(with: titles)
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
    func didSelect(index: Int, segmentedControl: SegmentedControl) {
        let indexPath = IndexPath(row: index, section: 0)
        let item = dataSource.item(at: indexPath)

        displayViewController(item)
    }
}
