//
//  TutorialRootRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol TutorialRootInteractable: Interactable, TutorialFirstListener {
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
        }
    }

    init(interactor: TutorialRootInteractable,
         viewController: TutorialRootViewControllable,
         tutorialFirstBuilder: TutorialFirstBuildable
    ) {
        self.viewController = viewController
        self.tutorialFirstBuilder = tutorialFirstBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // MARK: - Private

    private let viewController: TutorialRootViewControllable
    private let navigationController = UINavigationController()
    
    private let tutorialFirstBuilder: TutorialFirstBuildable
    private var tutorialFirstRouter: Routing?
    
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
}
