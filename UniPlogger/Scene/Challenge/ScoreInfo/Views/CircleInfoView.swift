//
//  CircleInfoView.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/11/03.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

final class CircleInfoView: UIView {
    lazy var infoLabel = UILabel().then {
        $0.font = .notoSans(ofSize: 14, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    init() {
        super.init(frame: .zero)
        setUpView()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CircleInfoView {
    func setUpView() {
        addSubview(infoLabel)
    }
    
    func setUpLayout() {
        backgroundColor = UIColor(named: "scoreCircleColor")
        layer.cornerRadius = 40
        infoLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
