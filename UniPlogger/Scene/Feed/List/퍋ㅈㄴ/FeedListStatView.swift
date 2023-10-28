//
//  FeedListStatView.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class FeedListStatView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private let statTitleLabel = UILabel()
    private let statInnerContainer = UIView()
    private let weeklyTitleLabel = UILabel()
    private let weeklyCircleView = UIView()
    private let weeklyContentLabel = UILabel()
    private let monthlyTitleLabel = UILabel()
    private let monthlyCircleView = UIView()
    private let monthlyContentLabel = UILabel()
}

private extension FeedListStatView {
    func setup() {
        backgroundColor = UIColor(named: "color_logBackground")
        statTitleLabel.do {
            $0.text = "통계"
            $0.font = .notoSans(ofSize: 18, weight: .medium)
        }
        statInnerContainer.backgroundColor = .clear
        weeklyTitleLabel.do {
            $0.text = "주간"
            $0.font = .notoSans(ofSize: 14, weight: .regular)
        }
        weeklyCircleView.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 41
        }
        weeklyContentLabel.do {
            $0.text = "매주\n월"
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .notoSans(ofSize: 16, weight: .regular)
        }
        monthlyTitleLabel.do {
            $0.text = "월간"
            $0.font = .notoSans(ofSize: 14, weight: .regular)
        }
        monthlyCircleView.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 41
        }
        monthlyContentLabel.do {
            $0.text = "평균\n10회"
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .notoSans(ofSize: 16, weight: .regular)
        }
        [
            statTitleLabel,
            weeklyTitleLabel,
            weeklyCircleView,
            monthlyTitleLabel,
            monthlyCircleView
        ].forEach {
            addSubview($0)
        }
        weeklyCircleView.addSubview(weeklyContentLabel)
        monthlyCircleView.addSubview(monthlyContentLabel)
    }
    func layout() {
        statTitleLabel.snp.makeConstraints{
            $0.top.equalTo(14)
            $0.centerX.equalToSuperview()
        }
        
        weeklyCircleView.snp.makeConstraints{
            $0.bottom.equalTo(-20)
            $0.trailing.equalTo(statTitleLabel.snp.leading).offset(-32)
            $0.size.equalTo(82)
        }
        
        weeklyContentLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        weeklyTitleLabel.snp.makeConstraints{
            $0.centerX.equalTo(weeklyCircleView)
            $0.bottom.equalTo(weeklyCircleView.snp.top).offset(-10)
        }
        
        monthlyCircleView.snp.makeConstraints{
            $0.bottom.equalTo(-20)
            $0.leading.equalTo(statTitleLabel.snp.trailing).offset(32)
            $0.size.equalTo(82)
        }
        
        monthlyContentLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        monthlyTitleLabel.snp.makeConstraints{
            $0.centerX.equalTo(monthlyCircleView)
            $0.bottom.equalTo(monthlyCircleView.snp.top).offset(-10)
        }
    }
}
