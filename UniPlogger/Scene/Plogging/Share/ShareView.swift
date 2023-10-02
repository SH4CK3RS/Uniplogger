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

//final class ShareView: UIView {
//    init() {
//        super.init(frame: .zero)
//        setup()
//        layout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Private
//    private let backgroundImageView = UIImageView()
//    private let ploggingImageViewContainer = UIView()
//    private let ploggingImageView = PloggingImageView()
//    private let dismissButton = UIButton()
//    private let shareButtonView = UIView()
//    private let shareButton = UIButton()
//    
//    @objc 
//    private func touchUpDismissButton() {
//        guard let imageForSave = self.imageForShare else { return }
//        let photoManager = PhotoManager(albumName: "UniPlogger")
//        
//        guard AuthManager.shared.autoSave else {
//            showAlert(title: "사진을 저장하시겠습니까?",
//                      message: "사진을 자동으로 저장하시려면 환경설정을 확인해주세요.",
//                      confirm: (title: "YES", handler: { [weak self] action in
//                        DispatchQueue.main.async {
//                            self?.showAlert(title: "사진 저장", message: "사진이 저장되었습니다.")
//                        }
//                      }),
//                      cancel: (title: "NO", handler: { [weak self] action in
//                        self?.dismiss(animated: true, completion: nil)
//                      }))
//            return
//        }
//        photoManager.save(imageForSave) { (success, error) in
//            if success {
//                DispatchQueue.main.async {
//                    self.showAlert(title: "사진 저장", message: "사진이 저장되었습니다.")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.showAlert(title: "ERROR", message: error?.localizedDescription ?? "error")
//                }
//            }
//        }
//    }
//    
//    @objc 
//    private func touchUpShareButton() {
//        guard let imageForShare = self.imageForShare else { return }
//        
//        if !AuthManager.shared.autoSave {
//            showAlert(title: "사진을 저장하시겠습니까?",
//                      message: "사진을 저장해야만 공유가 가능합니다.",
//                      confirm: (title: "YES", handler: ({ [weak self] action in
//                        self?.shareImage(for: imageForShare)
//                      })),
//                      cancel: (title: "NO", handler: { _ in
//                        return
//                      }))
//        } else {
//            shareImage(for: imageForShare)
//        }
//    }
//}
//
//private extension ShareView {
//    func setup() {
//        let frame = UIScreen.main.bounds
//        backgroundImageView.do {
//            let image = UIImage(named: "mainBackground")
//            $0.image = image!.resizeTopAlignedToFill(newWidth: frame.width)
//            $0.contentMode = .top
//            $0.clipsToBounds = true
//        }
//        ploggingImageViewContainer.do {
//            $0.backgroundColor = .clear
//            $0.layer.cornerRadius = 10
//            $0.clipsToBounds = true
//        }
//        ploggingImageView.backgroundColor = .lightGray
//        dismissButton.do {
//            $0.setImage(UIImage(named: "share_dismiss"), for: .normal)
//            $0.backgroundColor = UIColor(named: "dismissColor")
//            $0.layer.cornerRadius = 20
//            $0.addTarget(self, action: #selector(touchUpDismissButton), for: .touchUpInside)
//        }
//        shareButton.do {
//            $0.setImage(UIImage(named: "share_instagram"), for: .normal)
//            $0.backgroundColor = UIColor(named: "shareColor")
//            $0.layer.cornerRadius = 50
//            $0.addTarget(self, action: #selector(touchUpShareButton), for: .touchUpInside)
//        }
//        
//        [backgroundImageView, ploggingImageViewContainer, dismissButton, shareButtonView, shareButton].forEach {
//            addSubview($0)
//        }
//        ploggingImageViewContainer.addSubview(ploggingImageView)
//    }
//    func layout() {
//        backgroundImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        ploggingImageViewContainer.snp.makeConstraints {
//            $0.size.equalTo(340)
//            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().offset(179)
//        }
//        ploggingImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        dismissButton.snp.makeConstraints {
//            $0.size.equalTo(40)
//            $0.top.equalToSuperview().offset(58)
//            $0.trailing.equalToSuperview().offset(-16)
//        }
//        shareButtonView.snp.makeConstraints {
//            $0.leading.trailing.bottom.equalToSuperview()
//            $0.top.equalTo(ploggingImageView.snp.bottom)
//        }
//        shareButton.snp.makeConstraints {
//            $0.size.equalTo(100)
//            $0.center.equalTo(shareButtonView)
//        }
//    }
//}
