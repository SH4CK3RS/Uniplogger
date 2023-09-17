//
//  TutorialSecondViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum TutorialSecondPresentableListenerRequest {
    case viewDidAppear
    case skipButtonTapped
    case nextButtonTapped
}

protocol TutorialSecondPresentableListener: AnyObject {
    func request(_ request: TutorialSecondPresentableListenerRequest)
}

final class TutorialSecondViewController: UIViewController, TutorialSecondPresentable, TutorialSecondViewControllable {
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.request(.viewDidAppear)
    }
    
    // MARK: - Internal
    weak var listener: TutorialSecondPresentableListener?
    func request(_ request: TutorialSecondPresentableRequest) {
        switch request {
        case let .appendText(text):
            mainView.appendText(text)
        }
    }
    
    // MARK: - Private
    private let mainView = TutorialSecondView()
}

extension TutorialSecondViewController: TutorialSecondViewListener {
    func action(_ action: TutorialSecondViewAction) {
        switch action {
        case .skipButtonTapped:
            listener?.request(.skipButtonTapped)
        case .nextButtonTapped:
            listener?.request(.nextButtonTapped)
        }
    }
}
