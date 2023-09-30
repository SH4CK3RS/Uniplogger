//
//  PloggingRootInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

enum PloggingRootRouterRequest {
    case routeToPloggingMain
    case routeToStartCounting
    case detachStartCounting
    case routeToPloggingRecord
}

protocol PloggingRootRouting: ViewableRouting {
    func request(_ request: PloggingRootRouterRequest)
}

protocol PloggingRootPresentable: Presentable {
    var listener: PloggingRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PloggingRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PloggingRootInteractor: PresentableInteractor<PloggingRootPresentable>, PloggingRootInteractable, PloggingRootPresentableListener {

    weak var router: PloggingRootRouting?
    weak var listener: PloggingRootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PloggingRootPresentable,
         stream: PloggingMutableStream) {
        self.stream = stream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.request(.routeToPloggingMain)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private let stream: PloggingMutableStream
}

// MARK: - PloggingMainListenerRequest
extension PloggingRootInteractor {
    func request(_ request: PloggingMainListenerRequest) {
        switch request {
        case .startButtonTapped:
            router?.request(.routeToStartCounting)
        case .stopButtonTapped:
            router?.request(.routeToPloggingRecord)
        }
        
    }
}

// MARK: - StartCountingListenerRequest
extension PloggingRootInteractor {
    func request(_ request: StartCountingListenerRequest) {
        switch request {
        case .countDidEnd:
            router?.request(.detachStartCounting)
            stream.updateCountingFinished()
        }
    }
}
