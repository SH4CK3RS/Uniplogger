//
//  TutorialSecondView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit

enum TutorialSecondViewAction {
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialSecondViewListener: AnyObject {
    func action(_ action: TutorialSecondViewAction)
}

final class TutorialSecondView: UIView {
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
        backgroundImageView.image = UIImage(named: "bg_tutorialSecond")!.resizeTopAlignedToFill(newWidth: frame.width)
    }
    
    // MARK: - Internal
    weak var listener: TutorialSecondViewListener?
    func appendText(_ text: Character) {
        let contentLabelText = contentLabel.text ?? ""
        contentLabel.text = contentLabelText + "\(text)"
    }
    
    // MARK: - Private
    private let backgroundImageView = UIImageView()
    private let skipButton = UIButton()
    private let hideLabel = UILabel()
    private let contentLabel = UILabel()
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
}

private extension TutorialSecondView {
    func setup() {
        backgroundImageView.contentMode = .top
        skipButton.do {
            $0.setAttributedTitle(UPStyle().font(.roboto(ofSize: 15, weight: .bold)).color(UIColor(hexString: "#999999")).kern(1.25).apply(to: "SKIP"), for: .normal)
            $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
            $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        }
        contentLabel.do {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.textColor = .white
            $0.font = .dynamicNotosans(fontSize: 20, weight: .bold)
        }
        hideLabel.do {
            $0.text = """
            회의에서는 다름 아닌,
            MVP 우주 청소부,
            ‘플로거짱'을 선정하여

            인생에 다신 없을 명예와
            아직 오염되지 않은
            소행성 ‘zmffls’을
            부상으로 준다고 한다!
            """
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
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        addSubview(backgroundImageView)
        addSubview(skipButton)
        addSubview(nextButtonView)
        addSubview(contentLabel)
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
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(64)
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
