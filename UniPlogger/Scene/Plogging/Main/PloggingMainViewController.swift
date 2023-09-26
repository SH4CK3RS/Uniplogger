//
//  PloggingMainViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import CoreLocation

enum PloggingMainPresentableListenerRequest {
    case viewDidLoad
    case startButtonTapped
    case pauseButtonTapped
    case resumeButtonTapped
    case stopButtonTapped
    case trashButtonTapped
    case addTrashCanConfirmButtonTapped
    case myLocationButtonTapped
    case closeCoachmarkButtonTapped
    case removeTrashCan(TrashcanAnnotation)
    case addTrashCan(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

protocol PloggingMainPresentableListener: AnyObject {
    func request(_ request: PloggingMainPresentableListenerRequest)
}

final class PloggingMainViewController: UIViewController, PloggingMainPresentable, PloggingMainViewControllable {

    weak var listener: PloggingMainPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    // MARK: - Internal
    func request(_ request: PloggingMainPresentableRequest) {
        switch request {
        case .showCoachmark:
            showCoachmark()
        case .hideCoachmark:
            hideCoachmark()
        }
    }
    // MARK: - Private
    private let mainView = PloggingMainView()
    
    private func showCoachmark() {
        tabBarController?.tabBar.alpha = 0
        mainView.showCoachmark()
    }
    
    private func hideCoachmark() {
        tabBarController?.tabBar.alpha = 0
        mainView.hideCoachmark()
    }
}

extension PloggingMainViewController: PloggingMainViewListener {
    func action(_ action: PloggingMainViewAction) {
        switch action {
        case .startButtonTapped:
            listener?.request(.startButtonTapped)
        case .pauseButtonTapped:
            listener?.request(.stopButtonTapped)
        case .resumeButtonTapped:
            listener?.request(.resumeButtonTapped)
        case .stopButtonTapped:
            listener?.request(.stopButtonTapped)
        case .trashButtonTapped:
            listener?.request(.trashButtonTapped)
        case .addTrashCanConfirmButtonTapped:
            listener?.request(.addTrashCanConfirmButtonTapped)
        case .myLocationButtonTapped:
            listener?.request(.myLocationButtonTapped)
        case .closeCoachmarkButtonTapped:
            listener?.request(.closeCoachmarkButtonTapped)
        case let .removeTrashCan(trashcanAnnotation):
            listener?.request(.removeTrashCan(trashcanAnnotation))
        case let .addTrashCan(latitude, longitude):
            listener?.request(.addTrashCan(latitude: latitude, longitude: longitude))
        }
    }
}
