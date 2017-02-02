//
//  ScorePicker.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 1/8/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public enum ScorePickerTeam: Int {
    case home = 0
    case away = 1
}

public class ScorePicker: UIView, Sizable {
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))    
    fileprivate let teamStackView = UIStackView(frame: .zero)
    fileprivate let homeLabel = UILabel(frame: .zero)
    fileprivate let awayLabel = UILabel(frame: .zero)
    
    fileprivate let pickerView = UIPickerView(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = (1.0 / UIScreen.main.scale)
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension ScorePicker {
    func set(name: String?, for team: ScorePickerTeam) {
        switch team {
        case .home:
            homeLabel.text = name
        case .away:
            awayLabel.text = name
        }
    }
    
    func name(for team: ScorePickerTeam) -> String? {
        switch team {
        case .home:
            return homeLabel.text
        case .away:
            return awayLabel.text
        }
    }
    
    func select(score: Int, for team: ScorePickerTeam) {
        guard team.rawValue < pickerView.numberOfComponents,
              score < pickerView.numberOfRows(inComponent: team.rawValue) else {
            return
        }
        
        pickerView.selectRow(score, inComponent: team.rawValue, animated: false)
    }
    
    func score(for team: ScorePickerTeam) -> Int {
        guard team.rawValue < pickerView.numberOfComponents else {
            return 0
        }
        
        return pickerView.selectedRow(inComponent: team.rawValue)
    }
}

// MARK: - Private

private extension ScorePicker {
    func configureViews() {
        addSubview(visualEffectView)
        
        teamStackView.axis = .horizontal
        teamStackView.spacing = 8.0
        teamStackView.distribution = .fillEqually
        teamStackView.alignment = .center
        addSubview(teamStackView)
        
        homeLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        homeLabel.textColor = UIColor.black
        homeLabel.textAlignment = .center
        homeLabel.numberOfLines = 0
        homeLabel.lineBreakMode = .byWordWrapping
        teamStackView.addArrangedSubview(homeLabel)
        
        awayLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        awayLabel.textColor = UIColor.black
        awayLabel.textAlignment = .center
        awayLabel.numberOfLines = 0
        awayLabel.lineBreakMode = .byWordWrapping
        teamStackView.addArrangedSubview(awayLabel)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        addSubview(pickerView)
    }
    
    func configureLayout() {
        visualEffectView.edgeAnchors == edgeAnchors
        
        teamStackView.topAnchor == topAnchor + 16.0
        teamStackView.horizontalAnchors == horizontalAnchors + 16.0
        
        pickerView.topAnchor == teamStackView.bottomAnchor + 16.0
        pickerView.horizontalAnchors == horizontalAnchors
        pickerView.bottomAnchor == bottomAnchor
        pickerView.heightAnchor == 160.0
    }
}

// MARK: - UIPickerViewDataSource

extension ScorePicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
}

// MARK: - UIPickerViewDelegate

extension ScorePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel(frame: .zero)
        label.text = String(row)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 44.0, weight: UIFontWeightBlack)
        label.textAlignment = .center
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIFont.systemFont(ofSize: 44.0, weight: UIFontWeightBlack).lineHeight + 16.0
    }
}
