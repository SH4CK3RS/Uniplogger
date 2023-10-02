//
//  ImagePreviewView.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum ImagepreviewViewAction {
    case nextButtonTapped
    case dismissButtonTapped
}

protocol ImagepreviewViewListener: AnyObject {
    func action(_ action: ImagepreviewViewAction)
}

final class ImagePreviewView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: ImagepreviewViewListener?
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    // MARK: - Private
    private let imageView = UIImageView()
    private let nextButton = UIButton()
    private let dismissButtonView = UIView()
    private let dismissImageView = UIImageView()
    private let dismissLabel = UILabel()
    
    @objc 
    private func nextButtonTapped() {
        listener?.action(.nextButtonTapped)
    }
    
    @objc 
    private func dismissButtonTapped() {
        listener?.action(.dismissButtonTapped)
    }
}

private extension ImagePreviewView {
    func setup() {
        backgroundColor = .black
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        nextButton.do {
            $0.setImage(UIImage(named: "camera_next"), for: .normal)
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
        dismissButtonView.do {
            $0.backgroundColor = .clear
            $0.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
            $0.addGestureRecognizer(gesture)
        }
        dismissImageView.do {
            $0.image = UIImage(named: "camera_dismiss")
        }
        dismissLabel.do {
            $0.text = "촬영"
            $0.textColor = .white
            $0.font = .notoSans(ofSize: 17, weight: .regular)
        }
            
        [imageView, nextButton, dismissButtonView, dismissLabel, dismissImageView].forEach {
            addSubview($0)
        }
    }
    func layout() {
        let frame = UIScreen.main.bounds
        imageView.snp.makeConstraints {
            $0.top.equalTo(frame.height * 0.211)
            $0.width.equalTo(frame.width)
            $0.height.equalTo(frame.width)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.width.equalTo(136)
            $0.height.equalTo(52)
            $0.bottom.equalTo(-frame.height * 0.106)
        }
        dismissButtonView.snp.makeConstraints{
            $0.top.equalTo(44)
            $0.leading.equalTo(9)
            $0.width.equalTo(80)
            $0.height.equalTo(44)
        }
        dismissImageView.snp.makeConstraints {
            $0.leading.centerY.equalTo(dismissButtonView)
            $0.width.equalTo(12)
            $0.height.equalTo(21)
        }
        dismissLabel.snp.makeConstraints {
            $0.leading.equalTo(dismissImageView.snp.trailing).offset(5.05)
            $0.centerY.equalTo(dismissButtonView)
        }
    }
}