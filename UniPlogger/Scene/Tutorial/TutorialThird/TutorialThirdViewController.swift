//
//  TutorialThirdViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

enum TutorialThirdPresentableListenerRequest {
    case viewDidAppear
    case nicknameChanged(String)
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialThirdPresentableListener: AnyObject {
    func request(_ request: TutorialThirdPresentableListenerRequest)
}

final class TutorialThirdViewController: UIViewController, TutorialThirdPresentable, TutorialThirdViewControllable {

    weak var listener: TutorialThirdPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.viewDidAppear)
    }
    
    // MARK: - Internal
    func request(_ request: TutorialThirdPresentableRequest) {
        switch request {
        case .showEmptyNicknameError:
            showEmptyNicknameError()
        case .focusOnNicknameField:
            mainView.focusOnNicknameField()
        }
    }
    
    // MARK: - Private
    private let mainView = TutorialThirdView()
    
    private func showEmptyNicknameError() {
        errorAlert(title: "닉네임을 입력해주세요", message: "Uniplogger 을(를) 사용하기 위해서는 닉네임이 필요합니다.", completion: nil)
    }
}

extension TutorialThirdViewController: TutorialThirdViewListener {
    func actino(_ action: TutorialThirdViewAction) {
        switch action {
        case let .nicknameChanged(nickname):
            listener?.request(.nicknameChanged(nickname))
        case .skipButtonTapped:
            listener?.request(.skipButtonTapped)
        case .nextButtonTapped:
            listener?.request(.nextButtonTapped)
        }
    }
}
