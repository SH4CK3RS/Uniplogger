//
//  CameraInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol CameraRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CameraPresentable: Presentable {
    var listener: CameraPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum CameraListenerRequest {
    case didTakePhoto(UIImage)
}
protocol CameraListener: AnyObject {
    func request(_ request: CameraListenerRequest)
}

final class CameraInteractor: PresentableInteractor<CameraPresentable>, CameraInteractable, CameraPresentableListener {

    weak var router: CameraRouting?
    weak var listener: CameraListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CameraPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    func request(_ request: CameraPresentableListenerRequest) {
        switch request {
        case let .didTakePhoto(photo):
            listener?.request(.didTakePhoto(photo))
        }
    }
}
