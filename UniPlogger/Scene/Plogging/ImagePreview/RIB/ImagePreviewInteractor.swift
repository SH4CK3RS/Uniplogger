//
//  ImagePreviewInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ImagePreviewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum ImagePreviewPresentableRequest {
    case setImage(UIImage)
}

protocol ImagePreviewPresentable: Presentable {
    var listener: ImagePreviewPresentableListener? { get set }
    func request(_ request: ImagePreviewPresentableRequest)
}

protocol ImagePreviewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ImagePreviewInteractor: PresentableInteractor<ImagePreviewPresentable>, ImagePreviewInteractable, ImagePreviewPresentableListener {

    weak var router: ImagePreviewRouting?
    weak var listener: ImagePreviewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ImagePreviewPresentable,
         image: UIImage) {
        self.image = image
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: ImagePreviewPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.setImage(image))
        case .nextButtonTapped: break
        case .dismissButtonTapped: break
        }
    }
    // MARK: - Private
    private let image: UIImage
}

