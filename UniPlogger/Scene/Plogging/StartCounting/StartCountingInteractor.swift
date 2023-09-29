//
//  StartCountingInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

protocol StartCountingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol StartCountingPresentable: Presentable {
    var listener: StartCountingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum StartCountingListenerRequest {
    case countDidEnd
}

protocol StartCountingListener: AnyObject {
    func request(_ request: StartCountingListenerRequest)
}

final class StartCountingInteractor: PresentableInteractor<StartCountingPresentable>, StartCountingInteractable, StartCountingPresentableListener {

    weak var router: StartCountingRouting?
    weak var listener: StartCountingListener?
    
    override init(presenter: StartCountingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    func request(_ request: StartCountingPresentableListenerRequest) {
        listener?.request(.countDidEnd)
    }
}
