//
//  ShareView.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum ShareViewAction {
    case dismissButtonTapped(UIImage)
    case shareButtonTapped(UIImage)
}

protocol ShareViewListener: AnyObject {
    func action(_ action: ShareViewAction)
}

final class ShareView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: ShareViewListener?
    func showUploadedFeed(_ feed: Feed) {
        ploggingInfoView.updateInfo(with: feed)
    }
    
    var mergedImage: UIImage? {
        ploggingInfoView.asImage()
    }
    
    // MARK: - Private
    private let backgroundImageView = UIImageView()
    private let ploggingImageViewContainer = UIView()
    private let ploggingInfoView = PloggingInfoView()
    private let dismissButton = UIButton()
    private let shareButtonView = UIView()
    private let shareButton = UIButton()
    
    @objc 
    private func dismissButtonTapped() {
        guard let mergedImage else { return }
        listener?.action(.dismissButtonTapped(mergedImage))
    }
    
    @objc 
    private func shareButtonTapped() {
        guard let mergedImage else { return }
        listener?.action(.shareButtonTapped(mergedImage))
    }
}

private extension ShareView {
    func setup() {
        let frame = UIScreen.main.bounds
        backgroundImageView.do {
            let image = UIImage(named: "mainBackground")
            $0.image = image!.resizeTopAlignedToFill(newWidth: frame.width)
            $0.contentMode = .top
            $0.clipsToBounds = true
        }
        ploggingImageViewContainer.do {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        dismissButton.do {
            $0.setImage(UIImage(named: "share_dismiss"), for: .normal)
            $0.backgroundColor = UIColor(named: "dismissColor")
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        }
        shareButton.do {
            $0.setImage(UIImage(named: "share_instagram"), for: .normal)
            $0.backgroundColor = UIColor(named: "shareColor")
            $0.layer.cornerRadius = 50
            $0.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        }
        
        [backgroundImageView, ploggingImageViewContainer, dismissButton, shareButtonView, shareButton].forEach {
            addSubview($0)
        }
        ploggingImageViewContainer.addSubview(ploggingInfoView)
    }
    func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        ploggingImageViewContainer.snp.makeConstraints {
            $0.size.equalTo(340)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(179)
        }
        ploggingInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(58)
            $0.trailing.equalToSuperview().offset(-16)
        }
        shareButtonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(ploggingInfoView.snp.bottom)
        }
        shareButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalTo(shareButtonView)
        }
    }
}
