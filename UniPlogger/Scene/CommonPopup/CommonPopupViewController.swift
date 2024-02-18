//
//  CommonPopupViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum CommonPopupViewPresenterAction {
    case confirmButtonTapped
}

protocol CommonPopupPresentableListener: AnyObject {
    func action(_ action: CommonPopupViewPresenterAction)
}

final class CommonPopupViewController: UIViewController, CommonPopupPresentable, CommonPopupViewControllable {
    
    weak var listener: CommonPopupPresentableListener?
    
    init(viewTypes: [CommonPopupView.ViewType]) {
        self.mainView = .init(viewTypes: viewTypes)
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    private let mainView: CommonPopupView
}

extension CommonPopupViewController: CommonPopupViewListener {
    func action(_ action: CommonPopupViewAction) {
        switch action {
        case .confirmButtonTapped:
            listener?.action(.confirmButtonTapped)
        }
    }
}
