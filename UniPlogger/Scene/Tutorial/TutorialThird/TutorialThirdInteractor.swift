//
//  TutorialThirdInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import Foundation

protocol TutorialThirdRouting: ViewableRouting {
}


enum TutorialThirdPresentableRequest {
    case showEmptyNicknameError
    case focusOnNicknameField
}

protocol TutorialThirdPresentable: Presentable {
    var listener: TutorialThirdPresentableListener? { get set }
    func request(_ request: TutorialThirdPresentableRequest)
}

enum TutorialThirdListenerReqeust {
    case skip
    case next(String)
}
protocol TutorialThirdListener: AnyObject {
    func request(_ request: TutorialThirdListenerReqeust)
}

final class TutorialThirdInteractor: PresentableInteractor<TutorialThirdPresentable>, TutorialThirdInteractable, TutorialThirdPresentableListener {

    weak var router: TutorialThirdRouting?
    weak var listener: TutorialThirdListener?

    private var nickname: String = ""
    
    override init(presenter: TutorialThirdPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: TutorialThirdPresentableListenerRequest) {
        switch request {
        case .viewDidAppear:
            presenter.request(.focusOnNicknameField)
        case let .nicknameChanged(nickname):
            self.nickname = nickname
        case .skipButtonTapped:
            handleSkip()
        case .nextButtonTapped:
            handleNext()
        }
    }
    
    private func handleSkip() {
        listener?.request(.skip)
    }
    
    private func handleNext() {
        guard !nickname.isEmpty else {
            presenter.request(.showEmptyNicknameError)
            return
        }
        listener?.request(.next(nickname))
        UserDefaults.standard.set(true, forDefines: .hasTutorial)
    }
    
    
}
