//
//  ImagePreviewViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum ImagePreviewPresentableListenerRequest {
    case viewDidLoad
    case nextButtonTapped
    case dismissButtonTapped
}

protocol ImagePreviewPresentableListener: AnyObject {
    func request(_ request: ImagePreviewPresentableListenerRequest)
}

final class ImagePreviewViewController: UIViewController, ImagePreviewPresentable, ImagePreviewViewControllable {

    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    // MARK: - Internal
    weak var listener: ImagePreviewPresentableListener?
    func request(_ request: ImagePreviewPresentableRequest) {
        switch request {
        case let .setImage(image):
            mainView.setImage(image)
        }
    }
    
    // MARK: - Private
    private let mainView = ImagePreviewView()
}

extension ImagePreviewViewController: ImagepreviewViewListener {
    func action(_ action: ImagepreviewViewAction) {
        switch action {
        case .nextButtonTapped: listener?.request(.nextButtonTapped)
        case .dismissButtonTapped: listener?.request(.dismissButtonTapped)
        }
    }
}
