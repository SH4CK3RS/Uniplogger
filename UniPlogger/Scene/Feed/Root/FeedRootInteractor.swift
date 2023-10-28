//
//  FeedRootInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 10/28/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

enum FeedRootRouterRequest {
    case routeToFeedList
}

protocol FeedRootRouting: ViewableRouting {
    func request(_ request: FeedRootRouterRequest)
}

protocol FeedRootPresentable: Presentable {
    var listener: FeedRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FeedRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FeedRootInteractor: PresentableInteractor<FeedRootPresentable>, FeedRootInteractable, FeedRootPresentableListener {

    weak var router: FeedRootRouting?
    weak var listener: FeedRootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FeedRootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.request(.routeToFeedList)
    }
}
