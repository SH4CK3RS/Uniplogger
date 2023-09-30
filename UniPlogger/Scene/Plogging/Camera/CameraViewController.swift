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

protocol CameraPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
        
    }
}
