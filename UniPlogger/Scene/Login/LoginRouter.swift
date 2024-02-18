//
//  LoginRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol LoginInteractable: BaseInteractable {
    var loginRouter: LoginRouting? { get }
    var listener: LoginListener? { get set }
}

protocol LoginViewControllable: NavigatingViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginRouter: BaseRouter, LoginRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoginInteractable, viewController: LoginViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
