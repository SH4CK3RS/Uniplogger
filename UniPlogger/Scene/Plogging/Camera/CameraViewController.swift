//
//  CameraViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum CameraPresentableListenerRequest {
    case didTakePhoto(UIImage)
}
protocol CameraPresentableListener: AnyObject {
    func request(_ request: CameraPresentableListenerRequest)
}

final class CameraViewController: UIViewController, CameraPresentable, CameraViewControllable {
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.configureCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.stopSession()
    }

    // MARK: - Internal
    
    weak var listener: CameraPresentableListener?
    
    // MARK: - Private
    private let mainView = CameraView()
}

extension CameraViewController: CameraViewListener {
    func action(_ action: CameraViewAction) {
        switch action {
        case let .didTakePhoto(photo):
            listener?.request(.didTakePhoto(photo))
        }
    }
}
