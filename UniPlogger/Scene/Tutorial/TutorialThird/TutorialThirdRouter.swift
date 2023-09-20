//
//  TutorialThirdRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialThirdInteractable: Interactable {
    var router: TutorialThirdRouting? { get set }
    var listener: TutorialThirdListener? { get set }
}

protocol TutorialThirdViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TutorialThirdRouter: ViewableRouter<TutorialThirdInteractable, TutorialThirdViewControllable>, TutorialThirdRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TutorialThirdInteractable, viewController: TutorialThirdViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
