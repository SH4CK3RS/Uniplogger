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
    case viewDidAppear
    case startButtonTapped
    case pauseButtonTapped
    case resumeButtonTapped
    case stopButtonTapped
    case trashButtonTapped
    case addTrashCanConfirmButtonTapped
    case myLocationButtonTapped
    case closeCoachmarkButtonTapped
    case removeTrashCan(TrashcanAnnotation)
    case addTrashCanButtonTapped
    case addTrashCanTempAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.viewDidAppear)
    }
    
    // MARK: - Internal
    func request(_ request: PloggingMainPresentableRequest) {
        switch request {
        case .showCoachmark:
            showCoachmark()
        case .hideCoachmark:
            hideCoachmark()
        case .showLocationSetting:
            showLocationSetting()
        case let .goToMyLocation(location):
            mainView.setMyLocation(location)
        case let .showFetchedTrashCanAnnotations(trashCans):
            mainView.showFetchedTrashCanAnnotations(trashCans)
        case .prepareAddTrashCanTempAnnotation:
            mainView.prepareAddTrashCanTempAnnotation()
        case let .showAddressForAddTrashcanTempAnnotation(address):
            mainView.showAddressForAddTrashcanTempAnnotation(address)
        case .cancelAddTrashCanTempAnnotation:
            mainView.cancelAddTrashCanTempAnnotation()
        case let .addTrashCan(trashCan):
            mainView.addTrashCan(trashCan)
        case .startPlogging:
            mainView.startPlogging()
        case let .updateTime(timeText):
            mainView.updateTime(timeText)
        case let .updateDistance(distance):
            mainView.updateDistance(distance)
        case let .updateRoute(polyLine):
            mainView.updateRoute(polyLine)
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
    
    private func showLocationSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        let alert = UIAlertController(title: "위치 권한 필요", message: "플로깅 중 경로 기록을 위해 설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "권한설정", style: .default, handler: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension PloggingMainViewController: PloggingMainViewListener {
    func action(_ action: PloggingMainViewAction) {
        switch action {
        case .startButtonTapped:
            listener?.request(.startButtonTapped)
        case .pauseButtonTapped:
            listener?.request(.pauseButtonTapped)
        case .resumeButtonTapped:
            listener?.request(.resumeButtonTapped)
        case .stopButtonTapped:
            listener?.request(.stopButtonTapped)
        case .addTrashCanConfirmButtonTapped:
            listener?.request(.addTrashCanConfirmButtonTapped)
        case .myLocationButtonTapped:
            listener?.request(.myLocationButtonTapped)
        case .closeCoachmarkButtonTapped:
            listener?.request(.closeCoachmarkButtonTapped)
        case let .removeTrashCan(trashcanAnnotation):
            listener?.request(.removeTrashCan(trashcanAnnotation))
        case .addTrashCanButtonTapped:
            listener?.request(.addTrashCanButtonTapped)
        case let .addTrashCanTempAnnotation(latitude, longitude):
            listener?.request(.addTrashCanTempAnnotation(latitude: latitude, longitude: longitude))
        }
    }
}
