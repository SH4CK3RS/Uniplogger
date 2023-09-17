//
//  TutorialFirstRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialFirstInteractable: Interactable {
    var router: TutorialFirstRouting? { get set }
    var listener: TutorialFirstListener? { get set }
}

protocol TutorialFirstViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TutorialFirstRouter: ViewableRouter<TutorialFirstInteractable, TutorialFirstViewControllable>, TutorialFirstRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TutorialFirstInteractable, viewController: TutorialFirstViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
