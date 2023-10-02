//
//  TutorialFirstView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit

enum TutorialFirstViewAction {
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialFirstViewListener: AnyObject {
    func action(_ action: TutorialFirstViewAction)
}

final class TutorialFirstView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: TutorialFirstViewListener?
    func appendText(_ text: Character) {
        let contentLabelText = contentLabel.text ?? ""
        contentLabel.text = contentLabelText + "\(text)"
    }
    
    func updateBottomOffset() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
        UIView.animate(withDuration: 0.3) {
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    // MARK: - Private
    private var stopFlag = false
    private let fullText = """
    셀 수 없는 시간들이 지나,
    나날이 더러워지는 우주.

    그리고 이걸 두고 볼 수만은
    없다고 생각한 우주의 황제,
    우주황!

    긴급히 우주 청소부,
    플로거들을 소집했다!
    """
    
    private let backgroundImageView = UIImageView()
    private let scrollView = ScrollStackView()
    private let skipButtonContainer = UIView()
    private let skipButton = UIButton()
    private let kingImageViewContainer = UIView()
    private let kingImageView = UIImageView()
    private let contentLabelContainer = UIView()
    private let hideLabel = UILabel()
    private let contentLabel = UILabel()
    private let nextButtonContainer = UIView()
    private let nextButtonView = UIView()
    private let nextLabel = UILabel()
    private let nextImageView = UIImageView()
    private let nextButton = UIButton()
    
    @objc
    private func skipButtonTapped() {
        listener?.action(.skipButtonTapped)
    }
    
    @objc
    private func nextButtonTapped() {
        listener?.action(.nextButtonTapped)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.image = UIImage(named: "bg_tutorialFirst")!.resizeTopAlignedToFill(newWidth: frame.width)
    }
    
    
}

private extension TutorialFirstView {
    func setup() {
        backgroundImageView.contentMode = .top
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        skipButton.do {
            $0.setAttributedTitle(UPStyle().font(.roboto(ofSize: 15, weight: .bold)).color(UIColor(hexString: "#999999")).kern(1.25).apply(to: "SKIP"), for: .normal)
            $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
            $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        }
        kingImageView.do {
            $0.image = UIImage(named: "ic_tutorialFirstKing")
            $0.contentMode = .scaleAspectFit
        }
        hideLabel.do {
            $0.text = fullText
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 20, weight: .bold)
            $0.alpha = 0
        }
        contentLabel.do {
            $0.text = ""
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 20, weight: .bold)
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
        
        addSubview(backgroundImageView)
        addSubview(scrollView)
        
        scrollView.addArrangedSubview(skipButtonContainer)
        skipButtonContainer.addSubview(skipButton)
        scrollView.addArrangedSubview(contentLabelContainer)
        contentLabelContainer.addSubview(hideLabel)
        contentLabelContainer.addSubview(contentLabel)
        scrollView.addArrangedSubview(kingImageViewContainer)
        kingImageViewContainer.addSubview(kingImageView)
        scrollView.addArrangedSubview(nextButtonContainer)
        nextButtonContainer.addSubview(nextButtonView)
        nextButtonView.addSubview(nextLabel)
        nextButtonView.addSubview(nextImageView)
        nextButtonView.addSubview(nextButton)
    }
    
    func layout() {
        scrollView.containerView.snp.makeConstraints{
            $0.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        backgroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        skipButton.snp.makeConstraints {
            $0.top.equalTo(28)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-53)
        }
        
        hideLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.bottom.equalTo(-42)
        }
        contentLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        kingImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-16)
        }
        
        nextButtonView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalTo(-60)
            $0.trailing.equalTo(-20)
            $0.width.equalTo(134)
            $0.height.equalTo(52)
        }
        
        nextImageView.snp.makeConstraints{
            $0.trailing.equalTo(-30)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        nextLabel.snp.makeConstraints{
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview().offset(0.5)
        }
        
        nextButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
