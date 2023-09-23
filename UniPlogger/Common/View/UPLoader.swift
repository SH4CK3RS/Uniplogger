//
//  UPLoader.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/18.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit

final class UPLoader: UIView {
    static let shared = UPLoader()
    
    private init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let images: [UIImage] = [
        UIImage(named: "ic_loading001")!,
        UIImage(named: "ic_loading002")!,
        UIImage(named: "ic_loading003")!,
        UIImage(named: "ic_loading004")!,
        UIImage(named: "ic_loading005")!,
        UIImage(named: "ic_loading006")!
    ]
    
    private let timeInterval: TimeInterval = 10
    private var currentTime: TimeInterval = 10
    private var timer: Timer?
    
    
    private let loadingView = UIView()
    private let loadingImageView = UIImageView()
    
    
    func show() {
        if let delegate = UIApplication.shared.delegate,
           let window = delegate.window {
            window?.addSubview(self)
        }
        timerStart()
        loadingImageView.startAnimating()
    }
    
    func hidden(delay: Double = 0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseInOut, animations: {
            self.removeFromSuperview()
        }, completion: completion)
    }
    
    private func timerStart() {
        if timer != nil {
            timer = nil
            currentTime = timeInterval
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
            self?.currentTime -= 1
            
            if self?.timeInterval == 0 {
                self?.timerStop()
                self?.hidden()
            }
        })
    }
    
    func timerStop() {
        timer?.invalidate()
        currentTime = timeInterval
    }
}

private extension UPLoader {
    func setup() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        isUserInteractionEnabled = true
        loadingView.do {
            $0.frame = CGRect(x: 0, y: 0, width: 80, height: 90)
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.05
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 3
        }
        loadingImageView.do {
            $0.animationImages = images
            $0.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            $0.clipsToBounds = true
            $0.animationDuration = 3
        }
        addSubview(loadingView)
        loadingView.addSubview(loadingImageView)
    }
    
    func layout() {
        loadingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(90)
        }
        loadingImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(-10)
        }
    }
}
