//
//  TutorialSecondInteractor.swift
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
import AVFoundation

protocol TutorialSecondRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum TutorialSecondPresentableRequest {
    case appendText(Character)
}

protocol TutorialSecondPresentable: Presentable {
    var listener: TutorialSecondPresentableListener? { get set }
    func request(_ request: TutorialSecondPresentableRequest)
}

enum TutorialSecondListenerRequest {
    case skip
    case next
}

protocol TutorialSecondListener: AnyObject {
    func request(_ request: TutorialSecondListenerRequest)
}

final class TutorialSecondInteractor: PresentableInteractor<TutorialSecondPresentable>, TutorialSecondInteractable, TutorialSecondPresentableListener {

    weak var router: TutorialSecondRouting?
    weak var listener: TutorialSecondListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TutorialSecondPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func request(_ request: TutorialSecondPresentableListenerRequest) {
        switch request {
        case .viewDidAppear:
            animateText()
        case .skipButtonTapped:
            handleSkip()
        case .nextButtonTapped:
            handleNext()
        }
    }
    
    private func animateText() {
        var cnt = 0
        for t in content {
            if self.isStopped {
                break
            }
            cnt += 1
            if cnt % 4 == 0 {
                AudioServicesPlaySystemSound(1257)
            }
            presenter.request(.appendText(t))
            RunLoop.main.run(until: Date() + 0.075)
        }
    }
    
    private func handleSkip() {
        isStopped = true
        UserDefaults.standard.set(true, forDefines: .hasTutorial)
        listener?.request(.skip)
    }
    
    private func handleNext() {
        isStopped = true
        listener?.request(.next)
    }
    
    private var isStopped: Bool = false
    private let content: String = """
    회의에서는 다름 아닌,
    MVP 우주 청소부,
    ‘플로거짱'을 선정하여

    인생에 다신 없을 명예와
    아직 오염되지 않은
    소행성 ‘zmffls’을
    부상으로 준다고 한다!
    """
}
