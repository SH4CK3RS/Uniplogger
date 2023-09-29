//
//  StartCountingRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol StartCountingInteractable: Interactable {
    var router: StartCountingRouting? { get set }
    var listener: StartCountingListener? { get set }
}

protocol StartCountingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class StartCountingRouter: ViewableRouter<StartCountingInteractable, StartCountingViewControllable>, StartCountingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: StartCountingInteractable, viewController: StartCountingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
