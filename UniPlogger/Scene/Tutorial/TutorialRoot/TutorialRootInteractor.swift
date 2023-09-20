//
//  TutorialRootInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

enum TutorialRootRouterRequest {
    case cleanUpViews
    case routeToTutorialFirst
    case routeToTutorialSecond
    case routeToTutorialThird
}

protocol TutorialRootRouting: Routing {
    func request(_ reqeust: TutorialRootRouterRequest)
}

enum TutorialRootListenerRequest {
    case skip
    case next(String)
}

protocol TutorialRootListener: AnyObject {
    func request(_ request: TutorialRootListenerRequest)
}

final class TutorialRootInteractor: Interactor, TutorialRootInteractable {

    weak var router: TutorialRootRouting?
    weak var listener: TutorialRootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.request(.routeToTutorialFirst)
    }

    override func willResignActive() {
        super.willResignActive()
        router?.request(.cleanUpViews)
    }
}


// MARK: - TutorialFirstListenerRequest
extension TutorialRootInteractor {
    func request(_ request: TutorialFirstListenerRequest) {
        switch request {
        case .next: router?.request(.routeToTutorialSecond)
        case .skip: break
        }
    }
}

// MARK: - TutorialSecondListenerRequest
extension TutorialRootInteractor {
    func request(_ request: TutorialSecondListenerRequest) {
        switch request {
        case .next:
            router?.request(.routeToTutorialThird)
        case .skip: break
        }
    }
}

extension TutorialRootInteractor {
    func request(_ request: TutorialThirdListenerReqeust) {
        switch request {
        case .skip:
            listener?.request(.skip)
        case let .next(nickname):
            listener?.request(.next(nickname))
        }
    }
}
