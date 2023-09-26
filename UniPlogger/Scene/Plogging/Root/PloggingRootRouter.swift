//
//  PloggingRootRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingRootInteractable: Interactable, PloggingMainListener {
    var router: PloggingRootRouting? { get set }
    var listener: PloggingRootListener? { get set }
}

protocol PloggingRootViewControllable: ViewControllable {
    func set(viewControllers: [ViewControllable], animated: Bool)
    func push(viewController: ViewControllable, animated: Bool)
}

final class PloggingRootRouter: ViewableRouter<PloggingRootInteractable, PloggingRootViewControllable>, PloggingRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: PloggingRootInteractable,
         viewController: PloggingRootViewControllable,
         ploggingMainBuilder: PloggingMainBuildable) {
        self.ploggingMainBuilder = ploggingMainBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: PloggingRootRouterRequest) {
        switch request {
        case .routeToPloggingMain:
            routeToPloggingMain()
        }
    }
    
    private let ploggingMainBuilder: PloggingMainBuildable
    private var ploggingMainRouter: PloggingMainRouting?
    
    private func routeToPloggingMain() {
        let router = ploggingMainBuilder.build(withListener: interactor)
        ploggingMainRouter = router
        attachChild(router)
        viewController.set(viewControllers: [router.viewControllable], animated: false)
    }
}
