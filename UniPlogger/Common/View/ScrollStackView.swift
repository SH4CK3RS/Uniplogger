//
//  ScrollStackView.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/10/25.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import Then
import SnapKit

final class ScrollStackView: UIScrollView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let stackView = UIStackView()

    func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
}

private extension ScrollStackView {
    func setup() {
        contentInsetAdjustmentBehavior = .never
        stackView.do {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = 0
        }
        addSubview(stackView)
    }
    
    func layout() {
        stackView.snp.makeConstraints{
            $0.edges.width.equalToSuperview()
        }
    }
}
