//
//  TutorialThirdView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit

enum TutorialThirdViewAction {
    case nicknameChanged(String)
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialThirdViewListener: AnyObject {
    func actino(_ action: TutorialThirdViewAction)
}

final class TutorialThirdView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.image = UIImage(named: "bg_tutorialThird")!.resizeTopAlignedToFill(newWidth: frame.width)
    }
    
    // MARK: - Internal
    weak var listener: TutorialThirdViewListener?
    func focusOnNicknameField() {
        nicknameField.becomeFirstResponder()
    }
    // MARK: - Private
    private let backgroundImageView = UIImageView()
    private let skipButton = UIButton()
    private let ploggerImageView = UIImageView()
    private let ploggerBubbleImageView = UIImageView()
    private let nicknameContainer = UIView()
    private let nicknameField = NicknameField()
    private let nicknameLabel = UILabel()
    private let firstLabel = UILabel()
    private let 은 = UILabel()
    private let secondLabel = UILabel()
    private let nextButtonView = UIView()
    private let nextLabel = UILabel()
    private let nextImageView = UIImageView()
    private let nextButton = UIButton()
    
    @objc
    private func nextButtonTapped() {
        listener?.actino(.nextButtonTapped)
    }
    
    
    @objc
    private func nicknameChanged(textField: UITextField) {
        let text = textField.text ?? ""
        listener?.actino(.nicknameChanged(text))
        self.nicknameField.invalidateIntrinsicContentSize()
        if !text.isEmpty {
            nicknameLabel.text = text
        } else {
            nicknameLabel.text = "나에게 이름을\n만들어 주세요"
        }
    }
    
    
    @objc
    private func skipButtonTapped() {
        listener?.actino(.skipButtonTapped)
    }
}

private extension TutorialThirdView {
    func setup() {
        backgroundImageView.contentMode = .top
        skipButton.do {
            $0.setAttributedTitle(UPStyle().font(.roboto(ofSize: 15, weight: .bold)).color(UIColor(hexString: "#999999")).kern(-0.41).apply(to: "로그인하러가기"), for: .normal)
            $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
            $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        }
        ploggerImageView.do {
            $0.image = UIImage(named: "ic_tutorialThirdPlogger")
            $0.contentMode = .scaleAspectFit
        }
        ploggerBubbleImageView.do {
            $0.image = UIImage(named: "ic_tutorialThirdPloggerBubble")
            $0.contentMode = .scaleAspectFit
        }
        nicknameField.do {
            $0.borderStyle = .none
            $0.font = .dynamicNotosans(fontSize: 24, weight: .bold)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.addTarget(self, action: #selector(nicknameChanged), for: .editingChanged)
            $0.attributedPlaceholder = NSMutableAttributedString().string("(여기를 눌러 닉네임을 입력하세요)", font: .dynamicNotosans(fontSize: 20, weight: .bold), color: .white)
        }
        nicknameLabel.do {
            $0.textColor = .black
            $0.font = .notoSans(ofSize: 14, weight: .regular)
            $0.text = "나에게 이름을\n만들어 주세요"
            $0.numberOfLines = 2
        }
        firstLabel.do {
            $0.text = "신입 우주 청소부인"
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 24, weight: .bold)
        }
        은.do {
            $0.text = "은(는)"
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 24, weight: .bold)
        }
        secondLabel.do {
            $0.text = """
            ‘플로거짱'이 되고자하는
            새로운 목표를
            갖게 되는데...
            """
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 24, weight: .bold)
        }
        nextButtonView.do {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 26
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor(red: 196, green: 196, blue: 196).cgColor
        }
        nextLabel.do {
            $0.text = "NEXT"
            $0.textColor = .white
            $0.font = .roboto(ofSize: 15, weight: .bold)
        }
        nextImageView.do {
            $0.contentMode = .center
            $0.image = UIImage(named: "ic_BtnNextRight")
        }
        nextButton.do {
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
        
        addSubview(backgroundImageView)
        addSubview(skipButton)
        addSubview(nextButtonView)
        addSubview(ploggerImageView)
        addSubview(ploggerBubbleImageView)
        ploggerBubbleImageView.addSubview(nicknameLabel)
        addSubview(secondLabel)
        addSubview(nicknameContainer)
        nicknameContainer.addSubview(nicknameField)
        nicknameContainer.addSubview(은)
        addSubview(firstLabel)
        nextButtonView.addSubview(nextLabel)
        nextButtonView.addSubview(nextImageView)
        nextButtonView.addSubview(nextButton)
    }
    func layout() {
        backgroundImageView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(28)
            $0.trailing.equalTo(-20)
        }
        
        nextButtonView.snp.makeConstraints{
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-60)
            $0.trailing.equalTo(-32)
            $0.width.equalTo(134)
            $0.height.equalTo(52)
        }
        
        nextImageView.snp.makeConstraints{
            $0.trailing.equalTo(-30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        nextLabel.snp.makeConstraints{
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview().offset(0.5)
        }
        
        nextButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        ploggerImageView.snp.makeConstraints {
            $0.bottom.equalTo(nextButtonView.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        ploggerBubbleImageView.snp.makeConstraints{
            $0.bottom.equalTo(ploggerImageView.snp.top).offset(-11)
            $0.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-6)
        }
        
        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(32)
            $0.trailing.equalTo(-32)
            $0.bottom.equalTo(ploggerBubbleImageView.snp.top).offset(-40)
        }
        
        nicknameContainer.snp.makeConstraints {
            $0.bottom.equalTo(secondLabel.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        nicknameField.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        은.snp.makeConstraints{
            $0.leading.equalTo(nicknameField.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        firstLabel.snp.makeConstraints {
            $0.bottom.equalTo(은.snp.top)
            $0.centerX.equalToSuperview()
        }
    }
}

extension TutorialThirdView {
    class NicknameField: UITextField {
        override var intrinsicContentSize: CGSize{
            if let text, !text.isEmpty {
                let label = UILabel()
                label.font = font
                label.numberOfLines = 0
                label.textAlignment = .center
                label.text = text
                var originSize = super.intrinsicContentSize
                let newSize = label.sizeThatFits(originSize)
                return newSize
            } else {
                return super.intrinsicContentSize
            }
        }
    }
}
