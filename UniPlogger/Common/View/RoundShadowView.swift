//
//  RoundShadowView.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit

final class RoundShadowView: UIView {

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1.0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = self.layer.cornerRadius
        containerView.layer.masksToBounds = true

        addSubview(containerView)

        // pin the containerView to the edges to the view
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
