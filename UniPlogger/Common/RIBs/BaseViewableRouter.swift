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

enum BaseViewableRouterRequest {
    case showErrorAlert(String)
    case detachErrorAlert
}

protocol BaseViewableRouting: ViewableRouting, CommonPopupListener {
    func request(_ request: BaseViewableRouterRequest)
}

extension BaseViewableRouting {
    func request(_ request: CommonPopupListenerRequest) {
        switch request {
        case .confirm:
            self.request(.detachErrorAlert)
        }
    }
}

class BaseViewableRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, BaseViewableRouting {
    let commonPopupBuilder: CommonPopupBuilder = CommonPopupBuilder(dependency: EmptyComponent())
    var commonPopupRouter: ViewableRouting?
    
    func request(_ request: BaseViewableRouterRequest) {
        switch request {
        case let .showErrorAlert(message):
            showErrorAlert(withMessage: message)
        case .detachErrorAlert:
            detachErrorAlert()
        }
    }
    
    func showErrorAlert(withMessage message: String) {
        guard commonPopupRouter == nil else { return }
        
        let viewTypes: [CommonPopupView.ViewType] = [
            .spacer(23),
            .title(message)
        ]
        
        let router = commonPopupBuilder.build(withListener: self, viewTypes: viewTypes)
        self.commonPopupRouter = router
        attachChild(router)
        (viewController as? NavigatingViewControllable)?.present(router.viewControllable, animated: true, completion: nil)
    }
    
    func detachErrorAlert() {
        guard let commonPopupRouter else { return }
        self.commonPopupRouter = nil
        detachChild(commonPopupRouter)
        (viewController as? NavigatingViewControllable)?.dismiss(commonPopupRouter.viewControllable, animated: true, completion: nil)
    }
}
