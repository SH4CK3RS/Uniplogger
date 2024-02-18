//
//  BaseRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs
import UIKit

extension EmptyComponent: CommonPopupDependency {}

enum BaseRouterRequest {
    case showErrorAlert(String)
    case detachErrorAlert
}

protocol BaseRouting: ViewableRouting {
    func request(_ request: BaseRouterRequest)
}

protocol BaseInteractable: Interactable, CommonPopupListener {
    var router: BaseRouting? { get set }
}

extension BaseInteractable {
    func request(_ request: CommonPopupListenerRequest) {
        switch request {
        case .confirm:
            router?.request(.detachErrorAlert)
        }
    }
}

protocol NavigatingViewControllable: ViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?)
    func dismiss(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?)
}

extension NavigatingViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        uiviewController.present(viewController.uiviewController, animated: animated, completion: completion)
    }
    func dismiss(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        guard viewController.uiviewController === uiviewController.presentedViewController else { return }
        uiviewController.dismiss(animated: animated, completion: completion)
    }
}

class BaseRouter: ViewableRouter<BaseInteractable, NavigatingViewControllable>, BaseRouting {
    let commonPopupBuilder: CommonPopupBuilder = CommonPopupBuilder(dependency: EmptyComponent())
    var commonPopupRouter: ViewableRouting?
    
    func request(_ request: BaseRouterRequest) {
        switch request {
        case let .showErrorAlert(message):
            showErrorAlert(withMessage: message)
        case .detachErrorAlert:
            detachErrorAlert()
        }
    }
    
    func showErrorAlert(withMessage message: String) {
        guard commonPopupRouter == nil else { return }
        guard let interactor = interactable as? BaseInteractable else { return }
        
        let viewTypes: [CommonPopupView.ViewType] = [
            .spacer(23),
            .title(message)
        ]
        
        let router = commonPopupBuilder.build(withListener: interactor, viewTypes: viewTypes)
        self.commonPopupRouter = router
        attachChild(router)
        viewController.present(router.viewControllable, animated: true, completion: nil)
    }
    
    func detachErrorAlert() {
        guard let commonPopupRouter else { return }
        self.commonPopupRouter = nil
        detachChild(commonPopupRouter)
        viewController.dismiss(commonPopupRouter.viewControllable, animated: true, completion: nil)
    }
}
