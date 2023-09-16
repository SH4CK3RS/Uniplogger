//
//  WithdrawViewController+UI.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/12/05.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

extension WithdrawViewController {
    
    func setupViews() {
        [titleLabel, descriptionLabel, questionLabel, buttonStackView, cancelLabel, withdrawLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(20)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalTo(20)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(23)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(56)
        }
        cancelLabel.snp.makeConstraints {
            $0.center.equalTo(cancelButton)
        }
        withdrawLabel.snp.makeConstraints {
            $0.center.equalTo(withdrawButton)
        }
    }
    
}
