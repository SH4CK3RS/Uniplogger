//
//  CommonPopupRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs

protocol CommonPopupInteractable: Interactable {
    var router: CommonPopupRouting? { get set }
    var listener: CommonPopupListener? { get set }
}

protocol CommonPopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommonPopupRouter: ViewableRouter<CommonPopupInteractable, CommonPopupViewControllable>, CommonPopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CommonPopupInteractable, viewController: CommonPopupViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
