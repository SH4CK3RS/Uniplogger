//
//  FeedRootRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 10/28/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedRootInteractable: Interactable, FeedListListener {
    var router: FeedRootRouting? { get set }
    var listener: FeedRootListener? { get set }
}

protocol FeedRootViewControllable: ViewControllable {
    func set(viewControllers: [ViewControllable], animated: Bool)
    func push(viewController: ViewControllable, animated: Bool)
    func present(_ viewController: ViewControllable, animated: Bool)
    func dismiss(_ viewController: ViewControllable, animated: Bool)
}

final class FeedRootRouter: ViewableRouter<FeedRootInteractable, FeedRootViewControllable>, FeedRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FeedRootInteractable,
         viewController: FeedRootViewControllable,
         feedListBuilder: FeedListBuildable) {
        self.feedListBuilder = feedListBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: FeedRootRouterRequest) {
        switch request {
        case .routeToFeedList:
            routeToFeedList()
        }
    }
    
    private let feedListBuilder: FeedListBuildable
    private var feedListRouter: FeedListRouting?
    
    
    private func routeToFeedList() {
        let router = feedListBuilder.build(withListener: interactor)
        feedListRouter = router
        attachChild(router)
        viewController.set(viewControllers: [router.viewControllable], animated: false)
    }
}
