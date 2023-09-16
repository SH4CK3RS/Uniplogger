//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//


protocol SplashInteractable {
    var router: SplashRouting? { get set }
    var listener: SplashListener? { get set }
}

protocol SplashViewControllable: ViewControllable {
    
}

final class SplashRouter: SplashRouting {
    let viewController: SplashViewControllable
    let interactor: SplashInteractable
    
    init(interactor: SplashInteractable, viewController: SplashViewControllable) {
        self.interactor = interactor
        self.viewController = viewController
    }
}
