//
//  MainTabBarRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol MainTabBarInteractable: Interactable, PloggingRootListener, FeedRootListener {
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
         ploggingRootBuilder: PloggingRootBuildable,
         feedRootBuilder: FeedRootBuildable
    ) {
        self.ploggingRootBuilder = ploggingRootBuilder
        self.feedRootBuilder = feedRootBuilder
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
    
    private let feedRootBuilder: FeedRootBuildable
    private var feedRootRouter: FeedRootRouting?
    
    private func addChildren() {
        let ploggingRootRouter = ploggingRootBuilder.build(withListener: interactor)
        self.ploggingRootRouter = ploggingRootRouter
        let feedRootRouter = feedRootBuilder.build(withListener: interactor)
        self.feedRootRouter = feedRootRouter
        
        attachChild(ploggingRootRouter)
        attachChild(feedRootRouter)
        
        let ploggingItem = UITabBarItem(title: "플로깅", image: UIImage(named: "tabbar_plogging"), tag: 2)
        ploggingRootRouter.viewControllable.uiviewController.tabBarItem = ploggingItem
        let feedItem = UITabBarItem(title: "로그", image: UIImage(named: "tabbar_log"), tag: 3)
        feedRootRouter.viewControllable.uiviewController.tabBarItem = feedItem
        
        viewController.set(viewControllers: [
            ploggingRootRouter.viewControllable,
            feedRootRouter.viewControllable
        ])
    }
}
