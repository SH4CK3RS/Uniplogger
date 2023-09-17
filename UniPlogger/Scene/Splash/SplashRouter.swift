//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol SplashInteractable: Interactable, TutorialRootListener {
    var router: SplashRouting? { get set }
}

protocol SplashViewControllable: ViewControllable {
    
}

final class SplashRouter: LaunchRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    
    init(interactor: SplashInteractable,
         viewController: SplashViewControllable,
         tutorialRootBuilder: TutorialRootBuildable) {
        self.tutorialRootBuilder = tutorialRootBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: SplashRouterRequest) {
        switch request {
        case .routeToTutorial:
            routeToTutorialRoot()
        default:
            break
        }
    }
    
    private let tutorialRootBuilder: TutorialRootBuildable
    private var tutorialRootRouter: Routing?
    
    private func routeToTutorialRoot() {
        let router = tutorialRootBuilder.build(withListener: interactor)
        tutorialRootRouter = router
        attachChild(router)
    }
}
