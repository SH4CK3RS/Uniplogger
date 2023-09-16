//
//  TutorialFirstViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/05.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then
import AVFoundation

final class TutorialFirstViewController: UIViewController {
    private var stopFlag = false
    private let text = """
    셀 수 없는 시간들이 지나,
    나날이 더러워지는 우주.

    그리고 이걸 두고 볼 수만은
    없다고 생각한 우주의 황제,
    우주황!

    긴급히 우주 청소부,
    플로거들을 소집했다!
    """
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "bg_tutorialFirst")!.resizeTopAlignedToFill(newWidth: self.view.frame.width)
        $0.contentMode = .top
    }
    
    private let scrollView = ScrollStackView()
    
    private let skipButtonContainer = UIView()
    lazy var skipButton = UIButton().then {
        $0.setAttributedTitle(UPStyle().font(.roboto(ofSize: 15, weight: .bold)).color(UIColor(hexString: "#999999")).kern(1.25).apply(to: "SKIP"), for: .normal)
        $0.setTitleColor(.init(hexString: "#999999"), for: .normal)
        $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    private let kingImageViewContainer = UIView()
    
    private let kingImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_tutorialFirstKing")
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentLabelContainer = UIView()
    
    private let hideLabel = UILabel().then {
        $0.text = """
        셀 수 없는 시간들이 지나,
        나날이 더러워지는 우주.

        그리고 이걸 두고 볼 수만은
        없다고 생각한 우주의 황제,
        우주황!

        긴급히 우주 청소부,
        플로거들을 소집했다!
        """
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.font = .dynamicNotosans(fontSize: 20, weight: .bold)
        $0.alpha = 0
    }
    
    private let contentLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.font = .dynamicNotosans(fontSize: 20, weight: .bold)
    }
    
    private let nextButtonContainer = UIView()
    
    private let nextButtonView = UIView().then{
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 26
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(red: 196, green: 196, blue: 196).cgColor
    }
    
    private let nextLabel = UILabel().then{
        $0.text = "NEXT"
        $0.textColor = .white
        $0.font = .roboto(ofSize: 15, weight: .bold)
    }
    
    private let nextImageView = UIImageView().then{
        $0.contentMode = .center
        $0.image = UIImage(named: "ic_BtnNextRight")
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey: "QuestTutorial")
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(scrollView)
        scrollView.containerView.snp.makeConstraints{
            $0.width.equalTo(self.view)
        }
        
        scrollView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.addArrangedSubview(skipButtonContainer)
        skipButtonContainer.addSubview(skipButton)
        scrollView.addArrangedSubview(contentLabelContainer)
        contentLabelContainer.addSubview(hideLabel)
        contentLabelContainer.addSubview(contentLabel)
        scrollView.addArrangedSubview(kingImageViewContainer)
        kingImageViewContainer.addSubview(kingImageView)
        scrollView.addArrangedSubview(nextButtonContainer)
        nextButtonContainer.addSubview(nextButtonView)
        backgroundImageView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
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
        
        nextButtonView.addSubview(nextLabel)
        nextButtonView.addSubview(nextImageView)
        nextButtonView.addSubview(nextButton)
        
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
            $0.width.height.equalTo(24)
        }
        
        nextLabel.snp.makeConstraints{
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview().offset(0.5)
        }
        
        nextButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        var cnt = 0
        DispatchQueue.main.async {
            for t in self.hideLabel.text! {
                if self.stopFlag{
                    break
                }
                cnt += 1
                if cnt % 4 == 0 {
                    AudioServicesPlaySystemSound(1257)
                }
                self.contentLabel.text! += "\(t)"
                
                RunLoop.main.run(until: Date() + 0.075)
                
            }
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
            UIView.animate(withDuration: 0.3) {
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
        
        
    }
    
    @objc
    private func skipButtonTapped() {
        self.stopFlag = true
        UserDefaults.standard.set(true, forDefines: .hasTutorial)
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        self.stopFlag = true
        self.navigationController?.pushViewController(TutorialSecondViewController(), animated: true)
    }
    
}
