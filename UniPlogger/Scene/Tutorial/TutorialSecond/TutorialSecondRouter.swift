//
//  TutorialSecondRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialSecondInteractable: Interactable {
    var router: TutorialSecondRouting? { get set }
    var listener: TutorialSecondListener? { get set }
}

protocol TutorialSecondViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TutorialSecondRouter: ViewableRouter<TutorialSecondInteractable, TutorialSecondViewControllable>, TutorialSecondRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TutorialSecondInteractable, viewController: TutorialSecondViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
