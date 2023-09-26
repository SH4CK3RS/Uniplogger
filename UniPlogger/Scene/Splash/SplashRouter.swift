//
//  SplashRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol SplashInteractable: Interactable, TutorialRootListener, RegistrationListener, LoginListener, MainTabBarListener {
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
         loginBuilder: LoginBuildable,
         registrationBuilder: RegistrationBuildable,
         mainTabBarBuilder: MainTabBarBuildable) {
        self.tutorialRootBuilder = tutorialRootBuilder
        self.loginBuilder = loginBuilder
        self.registrationBuilder = registrationBuilder
        self.mainTabBarBuilder = mainTabBarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: SplashRouterRequest) {
        switch request {
        case .routeToTutorial:
            routeToTutorialRoot()
        case let .routeToRegistration(entryPoint):
            routeToRegistration(entryPoint: entryPoint)
        case .detachTutorial:
            detachTutorialRoot()
        case .routeToLogin:
            routeToLogin()
        case let .detachLogin(completion):
            detachLogin(completion: completion)
        case let .detachRegistration(completion):
            detachRegistration(completion: completion)
        case .routeToMain:
            routeToMainTabBar()
        }
    }
    
    private let navigationController = UINavigationController()
    
    private let tutorialRootBuilder: TutorialRootBuildable
    private var tutorialRootRouter: Routing?
    
    private let loginBuilder: LoginBuildable
    private var loginRouter: LoginRouting?
    
    private let registrationBuilder: RegistrationBuildable
    private var registrationRouter: RegistrationRouting?
    
    private let mainTabBarBuilder: MainTabBarBuildable
    private var mainTabBarRouter: MainTabBarRouting?
    
    private func presentNavigationOrPush(with viewController: ViewControllable) {
        if navigationController.isPresented {
            navigationController.pushViewController(viewController.uiviewController, animated: true)
        } else {
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.setViewControllers([viewController.uiviewController], animated: false)
            self.viewController.present(navigationController, animated: true)
        }
    }
    
    private func dismissOrPop(with viewController: ViewControllable, completion: (()-> Void)? = nil) {
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            navigationController.setViewControllers([], animated: false)
            navigationController.dismiss(animated: true, completion: completion)
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
    
    private func routeToLogin() {
        let router = loginBuilder.build(withListener: interactor)
        loginRouter = router
        attachChild(router)
        presentNavigationOrPush(with: router.viewControllable)
    }
    
    private func detachLogin(completion: (() -> Void)?) {
        guard let router = loginRouter else { return }
        loginRouter = nil
        detachChild(router)
        dismissOrPop(with: router.viewControllable, completion: completion)
    }
    
    private func routeToRegistration(entryPoint: RegistrationEntryPoint) {
        let router = registrationBuilder.build(withListener: interactor, entryPoint: entryPoint)
        registrationRouter = router
        attachChild(router)
        presentNavigationOrPush(with: router.viewControllable)
    }
    
    private func detachRegistration(completion: (() -> Void)?) {
        guard let router = registrationRouter else { return }
        registrationRouter = nil
        detachChild(router)
        dismissOrPop(with: router.viewControllable, completion: completion)
    }
    
    private func routeToMainTabBar() {
        let router = mainTabBarBuilder.build(withListener: interactor)
        mainTabBarRouter = router
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.present(router.viewControllable, animated: true)
        attachChild(router)
    }
}
