//
//  TutorialFirstInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import AVFoundation

protocol TutorialFirstRouting: ViewableRouting {}

enum TutorialFirstPresentableRequest {
    case appendText(Character)
    case appendDidEnd
}
protocol TutorialFirstPresentable: Presentable {
    var listener: TutorialFirstPresentableListener? { get set }
    func request(_ request: TutorialFirstPresentableRequest)
}

enum TutorialFirstListenerRequest {
    case skip
    case next
}

protocol TutorialFirstListener: AnyObject {
    func request(_ request: TutorialFirstListenerRequest)
}

final class TutorialFirstInteractor: PresentableInteractor<TutorialFirstPresentable>, TutorialFirstInteractable, TutorialFirstPresentableListener {

    weak var router: TutorialFirstRouting?
    weak var listener: TutorialFirstListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TutorialFirstPresentable) {
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
    
    func request(_ request: TutorialFirstPresentableListenerRequest) {
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
        presenter.request(.appendDidEnd)
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
    셀 수 없는 시간들이 지나,
    나날이 더러워지는 우주.

    그리고 이걸 두고 볼 수만은
    없다고 생각한 우주의 황제,
    우주황!

    긴급히 우주 청소부,
    플로거들을 소집했다!
    """
}
