//
//  FeedDetailRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedDetailInteractable: Interactable {
    var router: FeedDetailRouting? { get set }
    var listener: FeedDetailListener? { get set }
}

protocol FeedDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FeedDetailRouter: ViewableRouter<FeedDetailInteractable, FeedDetailViewControllable>, FeedDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FeedDetailInteractable, viewController: FeedDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
