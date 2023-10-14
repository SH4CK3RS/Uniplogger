//
//  ShareRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 10/8/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol ShareInteractable: Interactable {
    var router: ShareRouting? { get set }
    var listener: ShareListener? { get set }
}

protocol ShareViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShareRouter: ViewableRouter<ShareInteractable, ShareViewControllable>, ShareRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ShareInteractable, viewController: ShareViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
