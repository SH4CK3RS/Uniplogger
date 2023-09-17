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
}

protocol TutorialRootRouting: Routing {
    func request(_ reqeust: TutorialRootRouterRequest)
}

protocol TutorialRootListener: AnyObject {}

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
        case .next: break
        case .skip: break
        }
    }
}
