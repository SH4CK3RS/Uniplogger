//
//  MyPageViewController+UI.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/24.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

extension MyPageViewController {
    
    func setUpViews() {
        [backgroundImageView, characterImageView, leftStarImageView, rightStarImageView, levelTitleLabel, levelLabel, rankTitleLabel, rankLabel, infoView, itemTableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    func setUpLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 0.36)
        }
        characterImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backgroundImageView).offset(-self.view.frame.height * 0.047)
            $0.width.equalTo(self.view.frame.width * 0.21)
            $0.height.equalTo(characterImageView.snp.width).multipliedBy(1.67)
        }
        leftStarImageView.snp.makeConstraints {
            $0.bottom.equalTo(backgroundImageView).offset(-self.view.frame.height * 0.093)
            $0.trailing.equalTo(characterImageView.snp.leading).offset(-self.view.frame.width * 0.08)
        }
        rightStarImageView.snp.makeConstraints {
            $0.top.equalTo(leftStarImageView.snp.top)
            $0.leading.equalTo(characterImageView.snp.trailing).offset(self.view.frame.width * 0.08)
        }
        levelTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(leftStarImageView)
            $0.centerY.equalTo(leftStarImageView).offset(-7)
        }
        rankTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(rightStarImageView)
            $0.centerY.equalTo(rightStarImageView).offset(-7)
        }
        levelLabel.snp.makeConstraints {
            $0.top.equalTo(levelTitleLabel.snp.bottom).offset(-7)
            $0.centerX.equalTo(levelTitleLabel)
        }
        rankLabel.snp.makeConstraints {
            $0.top.equalTo(rankTitleLabel.snp.bottom).offset(-7)
            $0.centerX.equalTo(rankTitleLabel)
        }
        infoView.snp.makeConstraints {
            $0.top.equalTo(backgroundImageView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        itemTableView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.top).offset(30)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(208)
        }
    }
    
}
