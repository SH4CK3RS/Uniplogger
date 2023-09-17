//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol SplashInteractable: Interactable {
    var router: SplashRouting? { get set }
}

protocol SplashViewControllable: ViewControllable {
    
}

final class SplashRouter: LaunchRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    
    override init(interactor: SplashInteractable, viewController: SplashViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: SplashRouterRequest) {
        
    }
}
