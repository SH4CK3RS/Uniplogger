//
//  TutorialRootRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol TutorialRootInteractable: Interactable, TutorialFirstListener, TutorialSecondListener {
    var router: TutorialRootRouting? { get set }
    var listener: TutorialRootListener? { get set }
}

protocol TutorialRootViewControllable: ViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool)
    func dismiss(_ viewController: ViewControllable, animated: Bool)
}

final class TutorialRootRouter: Router<TutorialRootInteractable>, TutorialRootRouting {
    func request(_ request: TutorialRootRouterRequest) {
        switch request {
        case .cleanUpViews:
            cleanupViews()
        case .routeToTutorialFirst:
            routeToTutorialFirst()
        case .routeToTutorialSecond:
            routeToTutorialSecond()
        }
    }

    init(interactor: TutorialRootInteractable,
         viewController: TutorialRootViewControllable,
         tutorialFirstBuilder: TutorialFirstBuildable,
         tutorialSecondBuilder: TutorialSecondBuildable
    ) {
        self.viewController = viewController
        self.tutorialFirstBuilder = tutorialFirstBuilder
        self.tutorialSecondBuilder = tutorialSecondBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // MARK: - Private

    private let viewController: TutorialRootViewControllable
    private let navigationController = UINavigationController()
    
    private let tutorialFirstBuilder: TutorialFirstBuildable
    private var tutorialFirstRouter: Routing?
    
    private let tutorialSecondBuilder: TutorialSecondBuildable
    private var tutorialSecondRouter: Routing?
    
    private func cleanupViews() {
        if navigationController.isPresented {
            viewController.dismiss(navigationController, animated: true)
        }
    }
    
    private func presentNavigationOrPush(with viewController: ViewControllable) {
        if navigationController.isPresented {
            navigationController.pushViewController(viewController.uiviewController, animated: true)
        } else {
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.isNavigationBarHidden = true
            navigationController.setViewControllers([viewController.uiviewController], animated: false)
            self.viewController.present(navigationController, animated: true)
        }
    }
    
    private func routeToTutorialFirst() {
        let router = tutorialFirstBuilder.build(withListener: interactor)
        tutorialFirstRouter = router
        attachChild(router)
        presentNavigationOrPush(with: router.viewControllable)
    }
    
    private func routeToTutorialSecond() {
        let router = tutorialSecondBuilder.build(withListener: interactor)
        tutorialSecondRouter = router
        attachChild(router)
        presentNavigationOrPush(with: router.viewControllable)
    }
}
