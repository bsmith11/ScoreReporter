//
//  AcknowledgementListViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class AcknowledgementListViewController: UIViewController, MessageDisplayable {
    fileprivate let dataSource: AcknowledgementListDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(dataSource: AcknowledgementListDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Acknowledgements"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
    }
}

// MARK: - Private

private extension AcknowledgementListViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(SettingsCell.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
}

// MARK: - UITableViewDataSource

extension AcknowledgementListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as SettingsCell
        let item = dataSource.itemAtIndexPath(indexPath)
        
        cell.configureWithTitle(item?.title)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AcknowledgementListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        let acknowledgementViewController = AcknowledgementViewController(acknowledgement: item)
        navigationController?.pushViewController(acknowledgementViewController, animated: true)
    }
}
