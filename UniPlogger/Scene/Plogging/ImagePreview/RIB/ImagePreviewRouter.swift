//
//  ImagePreviewRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol ImagePreviewInteractable: Interactable {
    var router: ImagePreviewRouting? { get set }
    var listener: ImagePreviewListener? { get set }
}

protocol ImagePreviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ImagePreviewRouter: ViewableRouter<ImagePreviewInteractable, ImagePreviewViewControllable>, ImagePreviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ImagePreviewInteractable, viewController: ImagePreviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
