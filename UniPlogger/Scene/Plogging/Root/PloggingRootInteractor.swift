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
    override init(presenter: PloggingRootPresentable) {
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
}
