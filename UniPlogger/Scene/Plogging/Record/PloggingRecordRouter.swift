//
//  PloggingRecordRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingRecordInteractable: Interactable {
    var router: PloggingRecordRouting? { get set }
    var listener: PloggingRecordListener? { get set }
}

protocol PloggingRecordViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PloggingRecordRouter: ViewableRouter<PloggingRecordInteractable, PloggingRecordViewControllable>, PloggingRecordRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PloggingRecordInteractable, viewController: PloggingRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
