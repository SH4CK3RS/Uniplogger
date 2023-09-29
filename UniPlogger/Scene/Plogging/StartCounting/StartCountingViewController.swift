//
//  StartCountingViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum StartCountingPresentableListenerRequest {
    case countDidEnd
}

protocol StartCountingPresentableListener: AnyObject {
    func request(_ request: StartCountingPresentableListenerRequest)
}

final class StartCountingViewController: UIViewController, StartCountingPresentable, StartCountingViewControllable {

    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.startCounting()
    }
    
    // MARK: - Internal
    weak var listener: StartCountingPresentableListener?
    
    // MARK: - Private
    private let mainView = StartCountingView()
}

extension StartCountingViewController: StartCountingViewListener {
    func action(_ action: StartCountingViewAction) {
        switch action {
        case .countDidEnd:
            listener?.request(.countDidEnd)
        }
    }
}
