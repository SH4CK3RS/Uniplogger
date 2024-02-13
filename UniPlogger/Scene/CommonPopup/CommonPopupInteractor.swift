//
//  CommonPopupInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs
import RxSwift

protocol CommonPopupRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CommonPopupPresentable: Presentable {
    var listener: CommonPopupPresentableListener? { get set }
}

enum CommonPopupListenerRequest {
    case confirm
}

protocol CommonPopupListener: AnyObject {
    func request(_ request: CommonPopupListenerRequest)
}

final class CommonPopupInteractor: PresentableInteractor<CommonPopupPresentable>, CommonPopupInteractable, CommonPopupPresentableListener {

    weak var router: CommonPopupRouting?
    weak var listener: CommonPopupListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CommonPopupPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func action(_ action: CommonPopupViewPresenterAction) {
        switch action {
        case .confirmButtonTapped:
            listener?.request(.confirm)
        }
    }
}
