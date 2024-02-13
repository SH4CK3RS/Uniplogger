//
//  CommonPopupView.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum CommonPopupViewAction {
    case confirmButtonTapped
}

protocol CommonPopupViewListener: AnyObject {
    func action(_ action: CommonPopupViewAction)
}

final class CommonPopupView: UIView {
    enum ViewType {
        case title(String)
        case message(String)
        case spacer(CGFloat)
        case custom(UIView)
    }
    
    enum Constants {
        static let textColor: UIColor = UIColor(named: "color_text")!
        static let borderColor: UIColor = .init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    }
    
    init(viewTypes: [ViewType]) {
        self.viewTypes = viewTypes
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CommonPopupViewListener?
    
    private let viewTypes: [ViewType]
    
    private let container = UIView()
    private let stackView = UIStackView()
    private let confirmButton = UIButton(type: .system)
    
    @objc
    private func confirmButtonTapped() {
        listener?.action(.confirmButtonTapped)
    }
}

private extension CommonPopupView {
    func setup() {
        backgroundColor = .black.withAlphaComponent(0.5)
        container.do {
            $0.backgroundColor = .mainBackgroundColor
            $0.layer.cornerRadius = 12
            $0.layer.masksToBounds = true
        }
        stackView.axis = .vertical
        confirmButton.do {
            $0.setTitle("닫기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .buttonEnabled
            $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        }
        addSubview(container)
        container.addSubview(stackView)
        container.addSubview(confirmButton)
        for viewType in viewTypes {
            switch viewType {
            case let .title(title):
                addTitleLabel(title)
            case let .message(message):
                addMessageLabel(message)
            case let .spacer(spacing):
                addSpacer(spacing)
            case let .custom(view):
                stackView.addArrangedSubview(view)
            }
        }
    }
    
    func layout() {
        container.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(30)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(52)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    
    func addTitleLabel(_ title: String) {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.textColor = Constants.textColor
            $0.font = .boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        stackView.addArrangedSubview(titleLabel)
    }
    
    func addMessageLabel(_ message: String) {
        let messageLabel = UILabel().then {
            $0.text = message
            $0.textColor = Constants.textColor
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        stackView.addArrangedSubview(messageLabel)
    }
    
    func addSpacer(_ spacing: CGFloat) {
        let spacer = UIView()
        spacer.snp.makeConstraints {
            $0.height.equalTo(spacing)
        }
        stackView.addArrangedSubview(spacer)
    }
}
