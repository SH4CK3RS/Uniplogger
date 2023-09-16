//
//  SplashView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit

final class SplashView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let splashImageView = UIImageView().then{
        $0.image = UIImage(named: "splashBackground")
        $0.contentMode = .scaleAspectFill
    }
}

private extension SplashView {
    func setup() {
        addSubview(splashImageView)
    }
    
    func layout() {
        splashImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
