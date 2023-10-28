//
//  FeedListLevelRankingView.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class FeedListLevelRankingView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private let backgroundImageView = UIImageView()
    private let ploggerImageView = UIImageView()
    private let yellowStarImageView = UIImageView()
    private let levelTitleLabel = UILabel()
    private let levelLabel = UILabel()
    private let pinkStarImageView = UIImageView()
    private let rankTItleLabel = UILabel()
    private let rankLabel = UILabel()
}

private extension FeedListLevelRankingView {
    func setup() {
        backgroundImageView.do {
            $0.image = UIImage(named: "mypage_background")
            $0.contentMode = .scaleToFill
        }
        ploggerImageView.do {
            $0.image = UIImage(named: "character")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        yellowStarImageView.do {
            $0.image = UIImage(named: "ic_logStarYellow")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        levelTitleLabel.do {
            $0.text = "레벨"
            $0.textColor = .black
            $0.font = .notoSans(ofSize: 14, weight: .regular)
        }
        levelLabel.do {
            $0.text = "15"
            $0.textColor = .black
            $0.font = .notoSans(ofSize: 20, weight: .bold)
        }
        pinkStarImageView.do {
            $0.image = UIImage(named: "ic_logStarPink")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        rankTItleLabel.do {
            $0.text = "상위"
            $0.textColor = .black
            $0.font = .notoSans(ofSize: 14, weight: .regular)
        }
        rankLabel.do {
            $0.text = "0%"
            $0.textColor = .black
            $0.font = .notoSans(ofSize: 20, weight: .bold)
        }
        [
            backgroundImageView, ploggerImageView,
            yellowStarImageView,
            pinkStarImageView
        ].forEach {
            addSubview($0)
        }
        [levelTitleLabel, levelLabel].forEach {
            yellowStarImageView.addSubview($0)
        }
        [rankTItleLabel, rankLabel].forEach {
            pinkStarImageView.addSubview($0)
        }
    }
    
    func layout() {
        let frame = UIScreen.main.bounds
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        ploggerImageView.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-frame.height * 0.047)
            $0.width.equalTo(frame.width * 0.21)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ploggerImageView.snp.width).multipliedBy(1.67)
        }
        
        yellowStarImageView.snp.makeConstraints{
            $0.bottom.equalTo(-frame.height * 0.093)
            $0.trailing.equalTo(ploggerImageView.snp.leading).offset(-frame.width * 0.08)
        }
        pinkStarImageView.snp.makeConstraints{
            $0.top.equalTo(yellowStarImageView.snp.top)
            $0.leading.equalTo(ploggerImageView.snp.trailing).offset(frame.width * 0.08)
        }
        
        levelTitleLabel.snp.makeConstraints{
            $0.centerX.equalTo(yellowStarImageView)
            $0.centerY.equalTo(yellowStarImageView).offset(-7)
        }
        
        levelLabel.snp.makeConstraints{
            $0.top.equalTo(levelTitleLabel.snp.bottom).offset(-7)
            $0.centerX.equalToSuperview()
        }
        
        rankTItleLabel.snp.makeConstraints{
            $0.centerX.equalTo(pinkStarImageView)
            $0.centerY.equalTo(pinkStarImageView).offset(-7)
        }
        
        rankLabel.snp.makeConstraints{
            $0.top.equalTo(rankTItleLabel.snp.bottom).offset(-7)
            $0.centerX.equalTo(rankTItleLabel)
        }
    }
}
