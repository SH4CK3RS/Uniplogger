//
//  MainTabBarRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol MainTabBarInteractable: Interactable, PloggingRootListener {
    var router: MainTabBarRouting? { get set }
    var listener: MainTabBarListener? { get set }
}

protocol MainTabBarViewControllable: ViewControllable {
    func set(viewControllers: [ViewControllable])
}

final class MainTabBarRouter: ViewableRouter<MainTabBarInteractable, MainTabBarViewControllable>, MainTabBarRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: MainTabBarInteractable,
         viewController: MainTabBarViewControllable,
         ploggingRootBuilder: PloggingRootBuildable
    ) {
        self.ploggingRootBuilder = ploggingRootBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: MainTabBarRouterRequest) {
        switch request {
        case .addChildren:
            addChildren()
        }
    }
    
    private let ploggingRootBuilder: PloggingRootBuildable
    private var ploggingRootRouter: PloggingRootRouting?
    
    private func addChildren() {
        let router = ploggingRootBuilder.build(withListener: interactor)
        ploggingRootRouter = router
        attachChild(router)
        viewController.set(viewControllers: [router.viewControllable])
    }
}
