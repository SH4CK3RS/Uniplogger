//
//  MainTabBarInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

enum MainTabBarRouterRequest {
    case addChildren
}

protocol MainTabBarRouting: ViewableRouting {
    func request(_ request: MainTabBarRouterRequest)
}

protocol MainTabBarPresentable: Presentable {
    var listener: MainTabBarPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainTabBarListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainTabBarInteractor: PresentableInteractor<MainTabBarPresentable>, MainTabBarInteractable, MainTabBarPresentableListener {

    weak var router: MainTabBarRouting?
    weak var listener: MainTabBarListener?

    // in constructor.
    override init(presenter: MainTabBarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: MainTabBarPresentableListenerRequest) {
        switch request {
        case .viewDidAppear:
            router?.request(.addChildren)
        }
    }
}
