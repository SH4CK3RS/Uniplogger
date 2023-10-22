//
//  LogViewController+UI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/22.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit
extension LogViewController {
    func configuration() {
        self.navigationItem.title = "플로거짱 로그"
        self.view.backgroundColor = UIColor(named: "color_logBackground")
    }
    
    func setupView() {
        setupScrollView()
        //PloggerContainer
        scrollView.addArrangedSubview(ploggerContainer)
        ploggerContainer.addSubview(ploggerImageView)
        ploggerContainer.addSubview(yellowStarImageView)
        ploggerContainer.addSubview(pinkStarImageView)
        yellowStarImageView.addSubview(levelTitleLabel)
        yellowStarImageView.addSubview(levelLabel)
        pinkStarImageView.addSubview(rankTItleLabel)
        pinkStarImageView.addSubview(rankLabel)
        
        //StatContainer
        scrollView.addArrangedSubview(statContainer)
        statContainer.addSubview(statTitleLabel)
        statContainer.addSubview(weeklyTitleLabel)
        statContainer.addSubview(weeklyCircleView)
        weeklyCircleView.addSubview(weeklyContentLabel)
        statContainer.addSubview(monthlyTitleLabel)
        statContainer.addSubview(monthlyCircleView)
        monthlyCircleView.addSubview(monthlyContentLabel)
        //CollectionView
        scrollView.addArrangedSubview(collectionView)
    }
    
    func setupLayout() {
        setupPloggerContainer()
        setupStatContainer()
    }
  
    func setupNavigtationBar() {
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = .white
            navBar.barStyle = .black
            navBar.layer.cornerRadius = 30
            navBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            navBar.layer.masksToBounds = true
        }
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupPloggerContainer() {
        ploggerContainer.snp.makeConstraints{
            $0.height.equalTo(view.frame.height * 0.36)
        }
        ploggerImageView.snp.makeConstraints{
            $0.bottom.equalTo(ploggerContainer).offset(-view.frame.height * 0.047)
            $0.width.equalTo(view.frame.width * 0.21)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ploggerImageView.snp.width).multipliedBy(1.67)
        }
        
        yellowStarImageView.snp.makeConstraints{
            $0.bottom.equalTo(-view.frame.height * 0.093)
            $0.trailing.equalTo(ploggerImageView.snp.leading).offset(-view.frame.width * 0.08)
        }
        pinkStarImageView.snp.makeConstraints{
            $0.top.equalTo(yellowStarImageView.snp.top)
            $0.leading.equalTo(ploggerImageView.snp.trailing).offset(view.frame.width * 0.08)
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
    
    func setupStatContainer() {
        statContainer.snp.makeConstraints{
            $0.height.equalTo(182)
        }
        
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
    
    func setupCollectionView() {
        
    }
}
