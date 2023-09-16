//
//  LogOutTableViewCell.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/12/05.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

class LogOutInfoTableViewCell: UITableViewCell {

    static let ID = "logOutCell"
    
    var logOutItem: LogOutType = .logOut

    lazy var itemLabel = UILabel()
    lazy var nextImageView = UIImageView().then {
        $0.image = UIImage(named: "next_icon")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: LogOutType) {
        self.logOutItem = item
        itemLabel.text = logOutItem.description
        itemLabel.font = .notoSans(ofSize: 16, weight: .regular)
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        [itemLabel, nextImageView].forEach {
            self.addSubview($0)
        }
    }
    
    func setupLayout() {
        itemLabel.snp.makeConstraints {
            $0.leading.equalTo(8)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        nextImageView.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(6)
            $0.height.equalTo(12)
        }
    }

}
