//
//  PloggingRecordInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

protocol PloggingRecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PloggingRecordPresentable: Presentable {
    var listener: PloggingRecordPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum PloggingRecordListenerRequest {
    case takePhoto([PloggingItemType])
}

protocol PloggingRecordListener: AnyObject {
    func request(_ request: PloggingRecordListenerRequest)
}

final class PloggingRecordInteractor: PresentableInteractor<PloggingRecordPresentable>, PloggingRecordInteractable, PloggingRecordPresentableListener {
    
    weak var router: PloggingRecordRouting?
    weak var listener: PloggingRecordListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PloggingRecordPresentable) {
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
    
    func request(_ request: PloggingRecordPresentableListenerRequest) {
        switch request {
        case let .takePicture(items):
            listener?.request(.takePhoto(items))
        }
    }
}
