//
//  TutorialFirstViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import AVFoundation

enum TutorialFirstPresentableListenerRequest {
    case viewDidAppear
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialFirstPresentableListener: AnyObject {
    func request(_ request: TutorialFirstPresentableListenerRequest)
}

final class TutorialFirstViewController: UIViewController, TutorialFirstPresentable, TutorialFirstViewControllable {

    weak var listener: TutorialFirstPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.request(.viewDidAppear)
    }
    
    
    func request(_ request: TutorialFirstPresentableRequest) {
        switch request {
        case let .appendText(text):
            mainView.appendText(text)
        case .appendDidEnd:
            mainView.updateBottomOffset()
        }
    }
    
    private let mainView = TutorialFirstView()
}

extension TutorialFirstViewController: TutorialFirstViewListener {
    func action(_ action: TutorialFirstViewAction) {
        switch action {
        case .skipButtonTapped:
            listener?.request(.skipButtonTapped)
        case .nextButtonTapped:
            listener?.request(.nextButtonTapped)
        }
    }
}
