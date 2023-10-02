//
//  StartCountingView.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum StartCountingViewAction {
    case countDidEnd
}

protocol StartCountingViewListener: AnyObject {
    func action(_ action: StartCountingViewAction)
}

final class StartCountingView: UIView {
    
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Internal
    weak var listener: StartCountingViewListener?
    func startCounting() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCount), userInfo: nil, repeats: true)
    }
    
    // MARK: - Private
    private var count = 3
    private var timer: Timer?
    
    private let backgroundView = UIImageView()
    private let countLabel = UILabel()
    
    @objc 
    private func updateCount() {
        if(count > 1) {
            count -= 1
            countLabel.text = String(count)
        } else {
            self.timer?.invalidate()
            self.timer = nil
            listener?.action(.countDidEnd)
        }
    }
}

private extension StartCountingView {
    func setup() {
        backgroundView.do {
            if self.traitCollection.userInterfaceStyle == .dark {
                $0.image = UIImage(named: "countingDarkBackground")
            } else {
                $0.image = UIImage(named: "countingLightBackground")
            }
            $0.contentMode = .scaleAspectFill
        }
        countLabel.do {
            $0.text = "3"
            $0.font = .roboto(ofSize: 200, weight: .bold)
            $0.textColor = .white
        }
        
        addSubview(backgroundView)
        backgroundView.addSubview(countLabel)
    }
    
    func layout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
