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
import MapKit
import UIKit

protocol PloggingMainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum PloggingMainPresentableRequest {
    case showCoachmark
    case hideCoachmark
    case showLocationSetting
    case goToMyLocation(CLLocation)
    case showFetchedTrashCanAnnotations([TrashCan])
    case prepareAddTrashCanTempAnnotation
    case cancelAddTrashCanTempAnnotation
    case showAddressForAddTrashcanTempAnnotation(String)
    case addTrashCan(TrashCan)
    case startPlogging
    case updateTime(String)
    case updateDistance(String)
    case updateRoute(MultiColorPolyline)
}

protocol PloggingMainPresentable: Presentable {
    var listener: PloggingMainPresentableListener? { get set }
    func request(_ request: PloggingMainPresentableRequest)
}

enum PloggingMainListenerRequest {
    case startButtonTapped
    case stopButtonTapped(distance: Double, time: Int)
}

protocol PloggingMainListener: AnyObject {
    func request(_ request: PloggingMainListenerRequest)
}

final class PloggingMainInteractor: PresentableInteractor<PloggingMainPresentable>, PloggingMainInteractable, PloggingMainPresentableListener {
    enum AddTrashCanState {
        case none
        case adding(CLLocation)
    }
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PloggingMainPresentable,
         locationManager: LocationManagable,
         stream: PloggingStream,
         service: PloggingMainServiceable) {
        self.locationManager = locationManager
        self.stream = stream
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
        self.locationManager.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        bindStream()
    }
    
    // MARK: - Internal
    weak var router: PloggingMainRouting?
    weak var listener: PloggingMainListener?
    
    func request(_ request: PloggingMainPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            needToSetMyLocation = true
            getTrashCans()
        case .viewDidAppear:
            showCoachmarkIfNeeded()
            locationManager.requestPermission()
        case .closeCoachmarkButtonTapped:
            hideCoachmark()
        case .myLocationButtonTapped:
            handleMyLocation()
        case .addTrashCanButtonTapped:
            switch addTrashCanState {
            case .none:
                presenter.request(.prepareAddTrashCanTempAnnotation)
            case .adding:
                addTrashCanState = .none
                presenter.request(.cancelAddTrashCanTempAnnotation)
            }
        case let .addTrashCanTempAnnotation(latitude, longitude):
            handleAddTrashCanTempAnnotation(with: latitude, longitude: longitude)
        case .addTrashCanConfirmButtonTapped:
            handleAddTrashCanConfirm()
        case .startButtonTapped:
            listener?.request(.startButtonTapped)
        case .pauseButtonTapped:
            handlePausePlogging()
        case .resumeButtonTapped:
            handleResumePlogging()
        case .stopButtonTapped:
            handleStopPlogging()
        case let .removeTrashCan(annotation):
            print(annotation.coordinate)
        default: break
        }
    }
    
    // MARK: - Private
    private var locationManager: LocationManagable
    private var needToSetMyLocation: Bool = false
    private var model = PloggingMainModel()
    private let stream: PloggingStream
    private let service: PloggingMainServiceable
    private var timer: Timer?
    private var addTrashCanState: AddTrashCanState = .none
    
    private func bindStream() {
        stream.countingFinishedObservable
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.handleStartPlogging()
            }.disposeOnDeactivate(interactor: self)
    }
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
        if let currentLocation = model.currentLocation {
            presenter.request(.goToMyLocation(currentLocation))
        } else {
            needToSetMyLocation = true
            if !locationManager.isAuthorized {
                locationManager.requestPermission()
            }
        }
    }
    
    private func getTrashCans() {
        UPLoader.shared.show()
        service.getTrashCans()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, trashCans in
                UPLoader.shared.hidden()
                owner.presenter.request(.showFetchedTrashCanAnnotations(trashCans))
            } onFailure: { owner, error in
                UPLoader.shared.hidden()
                print(error.localizedDescription)
            }.disposeOnDeactivate(interactor: self)
    }
    
    private func handleAddTrashCanTempAnnotation(with latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.addTrashCanState = .adding(location)
        location.toAddress { [weak self] address in
            DispatchQueue.main.async {
                self?.presenter.request(.showAddressForAddTrashcanTempAnnotation(address))
            }
        }
    }
    
    private func handleAddTrashCanConfirm() {
        guard case let .adding(location) = addTrashCanState else { return }
        UPLoader.shared.show()
        service.addTrashCan(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        .observe(on: MainScheduler.instance)
        .subscribe(with: self) { owner, trashCan in
            UPLoader.shared.hidden()
            owner.presenter.request(.addTrashCan(trashCan))
        } onFailure: { owner, error in
            UPLoader.shared.hidden()
            print(error)
        }.disposeOnDeactivate(interactor: self)
    }
    
    private func handleStartPlogging() {
        model.start()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer), 
            userInfo: nil,
            repeats: true
        )
        presenter.request(.startPlogging)
    }
    
    private func handlePausePlogging() {
        locationManager.stopUpdateLocation()
        timer?.invalidate()
        timer = nil
    }
    
    private func handleResumePlogging() {
        locationManager.updateLocation()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func handleStopPlogging() {
        timer?.invalidate()
        timer = nil
        model.ploggingState = .stop
        listener?.request(.stopButtonTapped(distance: model.distance.value, time: model.time))
    }
    
    private func getPolyLine(first: CLLocation, second: CLLocation) -> MultiColorPolyline {
        let distance = second.distance(from: first)
        let time = second.timestamp.timeIntervalSince(first.timestamp)
        let speed = time > 0 ? distance / time : 0
        
        model.speeds.append(speed)
        model.minSpeed = min(model.minSpeed, speed)
        model.maxSpeed = max(model.maxSpeed, speed)
        
        let coords = [first.coordinate, second.coordinate]
        let segment = MultiColorPolyline(coordinates: coords, count: 2)
        segment.color = MKPolyline.segmentColor(
            speed: speed,
            midSpeed: model.midSpeed,
            slowestSpeed: model.minSpeed,
            fastestSpeed: model.maxSpeed
        )
        
        return segment
    }
    
    @objc 
    private func updateTimer() {
        model.seconds = model.seconds + 1
        if model.seconds == 60 {
            model.minutes += 1
            model.seconds = 0
        }
        
        let timeText = "\(String(format: "%02d", model.minutes)):\(String(format: "%02d", model.seconds))"
        presenter.request(.updateTime(timeText))
    }
}

extension PloggingMainInteractor: LocationManagerListener {
    func action(_ action: LocationManagerAction) {
        switch action {
        case let .locationUpdated(newLocation):
            if needToSetMyLocation {
                needToSetMyLocation = false
                presenter.request(.goToMyLocation(newLocation))
            }
            
            if let lastLocation = model.currentLocation,
                model.ploggingState == .doing {
                let delta = newLocation.distance(from: lastLocation)
                let polyLine = getPolyLine(first: lastLocation, second: newLocation)
                model.distance = model.distance + Measurement(value: delta, unit: UnitLength.meters)
                presenter.request(.updateDistance(model.distance.formattedString)) 
                presenter.request(.updateRoute(polyLine))
            }
            model.locationList.append(newLocation)
            
        case .locationAuthorized:
            locationManager.updateLocation()
        case .locationAuthDenied:
            presenter.request(.showLocationSetting)
        }
    }
}
