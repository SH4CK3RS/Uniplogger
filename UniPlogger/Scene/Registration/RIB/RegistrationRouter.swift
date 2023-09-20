//
//  RegistrationRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol RegistrationInteractable: Interactable {
    var router: RegistrationRouting? { get set }
    var listener: RegistrationListener? { get set }
}

protocol RegistrationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RegistrationRouter: ViewableRouter<RegistrationInteractable, RegistrationViewControllable>, RegistrationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: RegistrationInteractable, viewController: RegistrationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
