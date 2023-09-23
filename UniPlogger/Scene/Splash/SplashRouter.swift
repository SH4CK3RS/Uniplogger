//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol SplashInteractable: Interactable, TutorialRootListener, RegistrationListener {
    var router: SplashRouting? { get set }
}

protocol SplashViewControllable: ViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool)
    func dismiss(_ viewController: ViewControllable, animated: Bool)
}

final class SplashRouter: LaunchRouter<SplashInteractable, SplashViewControllable>, SplashRouting {
    
    init(interactor: SplashInteractable,
         viewController: SplashViewControllable,
         tutorialRootBuilder: TutorialRootBuildable,
         registrationBuilder: RegistrationBuildable) {
        self.tutorialRootBuilder = tutorialRootBuilder
        self.registrationBuilder = registrationBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: SplashRouterRequest) {
        switch request {
        case .routeToTutorial:
            routeToTutorialRoot()
        case let .routeToRegistration(nickname):
            routeToRegistration(nickname: nickname)
        case .detachTutorial:
            detachTutorialRoot()
        case .detachRegistration:
            detachRegistration()
        default:
            break
        }
    }
    
    private let navigationController = UINavigationController()
    
    private let tutorialRootBuilder: TutorialRootBuildable
    private var tutorialRootRouter: Routing?
    
    private let registrationBuilder: RegistrationBuildable
    private var registrationRouter: Routing?
    
    private func presentNavigationOrPush(with viewController: ViewControllable) {
        if navigationController.isPresented {
            navigationController.pushViewController(viewController.uiviewController, animated: true)
        } else {
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.setViewControllers([viewController.uiviewController], animated: false)
            self.viewController.present(navigationController, animated: true)
        }
    }
    
    private func routeToTutorialRoot() {
        let router = tutorialRootBuilder.build(withListener: interactor)
        tutorialRootRouter = router
        attachChild(router)
    }
    
    private func detachTutorialRoot() {
        guard let router = tutorialRootRouter else { return }
        tutorialRootRouter = nil
        detachChild(router)
    }
    
    private func routeToRegistration(nickname: String) {
        let router = registrationBuilder.build(withListener: interactor, entryPoint: .tutorial(nickname))
        registrationRouter = router
        attachChild(router)
        presentNavigationOrPush(with: router.viewControllable)
    }
    
    private func detachRegistration() {
        guard let router = registrationRouter else { return }
        registrationRouter = nil
        navigationController.dismiss(animated: true)
        detachChild(router)
    }
}
