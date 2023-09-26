//
//  PloggingMainRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingMainInteractable: Interactable {
    var router: PloggingMainRouting? { get set }
    var listener: PloggingMainListener? { get set }
}

protocol PloggingMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PloggingMainRouter: ViewableRouter<PloggingMainInteractable, PloggingMainViewControllable>, PloggingMainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PloggingMainInteractable, viewController: PloggingMainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
