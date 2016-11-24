//
//  SettingsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

class SettingsViewController: UIViewController, MessageDisplayable {
    fileprivate let dataSource: SettingsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(dataSource: SettingsDataSource) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = "Settings"

        let image = UIImage(named: "icn-settings")
        let selectedImage = UIImage(named: "icn-settings-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0.0, bottom: -5.5, right: 0.0)

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

        configureViews()
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        deselectRows(in: tableView, animated: animated)
    }
}

// MARK: - Private

private extension SettingsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: SettingsCell.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        view.addSubview(tableView)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath) as SettingsCell
        let item = dataSource.item(at: indexPath)

        cell.configure(with: item)
        cell.separatorHidden = indexPath.item == 0

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }

        switch item {
        case .acknowledgements:
            let acknowledgementListDataSource = AcknowledgementListDataSource()
            let acknowledgementListViewController = AcknowledgementListViewController(dataSource: acknowledgementListDataSource)
            navigationController?.pushViewController(acknowledgementListViewController, animated: true)
        default:
            break
        }
    }
}
