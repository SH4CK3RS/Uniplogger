//
//  PloggingMainInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import Foundation

protocol PloggingMainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum PloggingMainPresentableRequest {
    case showCoachmark
    case hideCoachmark
}

protocol PloggingMainPresentable: Presentable {
    var listener: PloggingMainPresentableListener? { get set }
    func request(_ request: PloggingMainPresentableRequest)
}

protocol PloggingMainListener: AnyObject {}

final class PloggingMainInteractor: PresentableInteractor<PloggingMainPresentable>, PloggingMainInteractable, PloggingMainPresentableListener {

    weak var router: PloggingMainRouting?
    weak var listener: PloggingMainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PloggingMainPresentable) {
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
    
    func request(_ request: PloggingMainPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            showCoachmarkIfNeeded()
        default: break
        }
    }
    
    private func showCoachmarkIfNeeded() {
        if !UserDefaults.standard.bool(forDefines: .ploggingCoachmark) {
            presenter.request(.showCoachmark)
        }
    }
}
