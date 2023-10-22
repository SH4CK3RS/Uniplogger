//
//  FeedListRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedListInteractable: Interactable {
    var router: FeedListRouting? { get set }
    var listener: FeedListListener? { get set }
}

protocol FeedListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FeedListRouter: ViewableRouter<FeedListInteractable, FeedListViewControllable>, FeedListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FeedListInteractable, viewController: FeedListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
