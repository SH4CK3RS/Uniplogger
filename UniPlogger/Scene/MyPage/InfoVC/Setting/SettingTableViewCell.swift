//
//  SettingTableViewCell.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {

    static let ID = "settingCell"
    
    var infoItem: SettingType = .autosave

    lazy var itemLabel = UILabel()
    lazy var switchButton = UISwitch().then {
        $0.tintColor = UIColor(named: "rankColor")
        $0.onTintColor = UIColor(named: "rankColor")
        $0.addTarget(self, action: #selector(onClickSwitch), for: UIControl.Event.valueChanged)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: SettingType) {
        self.infoItem = item
        itemLabel.text = infoItem.description
        itemLabel.font = .notoSans(ofSize: 16, weight: .regular)
        switch infoItem {
        case .autosave:
            switchButton.isOn = AuthManager.shared.autoSave
        }
    }
    
    @objc func onClickSwitch() {
        switch infoItem {
        case .autosave:
            AuthManager.shared.autoSave = switchButton.isOn
        }
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        [itemLabel, switchButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setupLayout() {
        itemLabel.snp.makeConstraints {
            $0.leading.equalTo(8)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        switchButton.snp.makeConstraints {
            $0.trailing.equalTo(-8.05)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(51)
            $0.height.equalTo(31)
        }
    }
}
