//
//  DetailViewController+UI.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/17.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func setUpViews() {
        navigationController?.navigationBar.tintColor = .text
        [backgroundImageView, ploggingImageViewContainer, shareButtonView].forEach {
            self.view.addSubview($0)
        }
        ploggingImageViewContainer.addSubview(ploggingInfoView)
        shareButtonView.addSubview(shareButton)
    }
    
    func setUpLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(-88)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        ploggingImageViewContainer.snp.makeConstraints {
            $0.size.equalTo(340)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(view.frame.height * 0.25)
        }
        
        ploggingInfoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(145)
        }
        
        shareButtonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(ploggingInfoView.snp.bottom)
        }
        shareButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalTo(shareButtonView)
        }
        shareButtonView.isHidden = true
    }
    
}
