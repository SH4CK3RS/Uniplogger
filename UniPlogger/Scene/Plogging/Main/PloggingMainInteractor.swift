//
//  PloggingMainInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import Foundation
import CoreLocation

protocol PloggingMainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum PloggingMainPresentableRequest {
    case showCoachmark
    case hideCoachmark
    case showLocationSetting
    case goToMyLocation(Location)
    case showAddressForAddTrashcan(String)
}

protocol PloggingMainPresentable: Presentable {
    var listener: PloggingMainPresentableListener? { get set }
    func request(_ request: PloggingMainPresentableRequest)
}

enum PloggingMainListenerRequest {
    case startButtonTapped
}

protocol PloggingMainListener: AnyObject {
    func request(_ request: PloggingMainListenerRequest)
}

final class PloggingMainInteractor: PresentableInteractor<PloggingMainPresentable>, PloggingMainInteractable, PloggingMainPresentableListener {

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PloggingMainPresentable,
         locationManager: LocationManagable) {
        self.locationManager = locationManager
        super.init(presenter: presenter)
        presenter.listener = self
        self.locationManager.listener = self
    }

    // MARK: - Internal
    weak var router: PloggingMainRouting?
    weak var listener: PloggingMainListener?
    
    func request(_ request: PloggingMainPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            needToSetMyLocation = true
        case .viewDidAppear:
            showCoachmarkIfNeeded()
            locationManager.requestPermission()
        case .closeCoachmarkButtonTapped:
            hideCoachmark()
        case .myLocationButtonTapped:
            handleMyLocation()
        case let .addTrashCan(latitude, longitude):
            handleAddTrashcan(with: latitude, longitude: longitude)
        case .startButtonTapped:
            listener?.request(.startButtonTapped)
        default: break
        }
    }
    
    // MARK: - Private
    private var locationManager: LocationManagable
    private var needToSetMyLocation: Bool = false
    private var lastLocation: Location?
    private func showCoachmarkIfNeeded() {
        if !UserDefaults.standard.bool(forDefines: .ploggingCoachmark) {
            presenter.request(.showCoachmark)
        }
    }
    
    private func hideCoachmark() {
        UserDefaults.standard.set(true, forDefines: .ploggingCoachmark)
        presenter.request(.hideCoachmark)
    }
    
    private func handleMyLocation() {
        if let lastLocation {
            presenter.request(.goToMyLocation(lastLocation))
        } else {
            needToSetMyLocation = true
            if !locationManager.isAuthorized {
                locationManager.requestPermission()
            }
        }
    }
    
    private func handleAddTrashcan(with latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.toAddress { [weak self] address in
            DispatchQueue.main.async {
                self?.presenter.request(.showAddressForAddTrashcan(address))
            }
        }
    }
}

extension PloggingMainInteractor: LocationManagerListener {
    func action(_ action: LocationManagerAction) {
        switch action {
        case let .routeUpdated(distance, location):
            lastLocation = location
            if needToSetMyLocation {
                needToSetMyLocation = false
                presenter.request(.goToMyLocation(location))
            }
        case .locationAuthorized:
            locationManager.updateLocation()
        case .locationAuthDenied:
            presenter.request(.showLocationSetting)
        }
    }
}
