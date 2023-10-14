//
//  PloggingInfoView.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/10/11.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class PloggingInfoView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func updateInfo(with feed: Feed) {
        distanceLabel.text = FormatDisplay.distance(feed.distance)
        timeLabel.text = "\(String(format: "%02d", feed.timeSet.minutes)):\(String(format: "%02d", feed.timeSet.seconds))"
        
        ImageDownloadManager.shared.downloadImage(url: feed.photo) { [weak self] image in
            DispatchQueue.main.async {
                self?.feedImageView.image = image
            }
        }
    }
    
    // MARK: - Private
    private let feedImageView = UIImageView()
    private let gradientView = GradientView()
    private let characterImageView = UIImageView()
    private let leftView = UIView()
    private let ploggerImageView = UIImageView()
    private let rightView = UIView()
    private let timerImageView = UIImageView()
    private let distanceLabel = UILabel()
    private let timeLabel = UILabel()
}

extension PloggingInfoView {
    func setup() {
        gradientView.do {
            $0.colors = [.clear, .black]
            $0.locations = [0.02, 1]
        }
        characterImageView.image = UIImage(named: "share_character")
        ploggerImageView.image = UIImage(named: "share_plogger")
        timerImageView.image = UIImage(named: "share_timer")
        distanceLabel.do {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .roboto(ofSize: 20, weight: .bold)
        }
        timeLabel.do {
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .roboto(ofSize: 20, weight: .bold)
        }
        [feedImageView, gradientView, characterImageView, leftView, rightView, ploggerImageView, timerImageView, distanceLabel, timeLabel].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(71)
            $0.height.equalTo(87)
        }
        leftView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(characterImageView.snp.leading)
            $0.top.equalToSuperview().offset(76)
        }
        rightView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(characterImageView.snp.trailing)
            $0.top.equalTo(leftView)
        }
        ploggerImageView.snp.makeConstraints {
            $0.top.centerX.equalTo(leftView)
            $0.size.equalTo(26)
        }
        timerImageView.snp.makeConstraints {
            $0.top.centerX.equalTo(rightView)
            $0.width.equalTo(22)
            $0.height.equalTo(25.67)
        }
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(ploggerImageView.snp.bottom).offset(2.38)
            $0.centerX.equalTo(ploggerImageView.snp.centerX)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(timerImageView.snp.bottom).offset(2.38)
            $0.centerX.equalTo(timerImageView.snp.centerX)
        }
    }
}
