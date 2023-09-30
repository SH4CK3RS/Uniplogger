//
//  CameraRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol CameraInteractable: Interactable {
    var router: CameraRouting? { get set }
    var listener: CameraListener? { get set }
}

protocol CameraViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CameraRouter: ViewableRouter<CameraInteractable, CameraViewControllable>, CameraRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CameraInteractable, viewController: CameraViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
