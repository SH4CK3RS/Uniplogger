//
//  PloggingInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
protocol PloggingBusinessLogic {
    func startPlogging()
    func pausePlogging()
    func resumePlogging()
    func stopPlogging(request: Plogging.StopPlogging.Request)
    func setupLocationService()
    func fetchTrashCan()
    
    //TrashCan
    func addTrashCan(request: Plogging.AddTrashCan.Request)
    func addConfirmTrashCan(request: Plogging.AddConfirmTrashCan.Request)
    func removeTrashCan(request: Plogging.RemoveTrashCan.Request)
}

protocol PloggingDataStore {
    var ploggingData: PloggingData? { get set }
}

class PloggingInteractor: NSObject, PloggingBusinessLogic, PloggingDataStore {
    var ploggingData: PloggingData?
    
    var presenter: PloggingPresentationLogic?
    var worker = PloggingWorker()
    //var name: String = ""
    func startPlogging() {
        worker.delegate = self
        worker.startRun()
        self.presenter?.presentStartPlogging()
    }
    
    func pausePlogging() {
        worker.delegate = nil
        worker.pauseRun()
        self.presenter?.presentPausePlogging()
    }
    
    func resumePlogging() {
        worker.delegate = self
        worker.resumeRun()
        self.presenter?.presentResumePlogging()
    }
    
    func stopPlogging(request: Plogging.StopPlogging.Request) {
        worker.delegate = nil
        worker.stopRun { [weak self] distance in
            
//            let ploggingData = PloggingData(distance: distance.converted(to: .kilometers), time: request.minutes * 60 + request.seconds, items: [])
//            self?.ploggingData = ploggingData
//            self?.presenter?.presentStopPlogging()
        }
    }
    
    func setupLocationService() {
        worker.updateAuthorization = { status in
            let response = Plogging.LocationAuth.Response(status: status)
            DispatchQueue.main.async { [weak self] in
              self?.presenter?.presentLocationService(response: response)
            }
        }
    }
    func fetchTrashCan() {
        UPLoader.shared.show()
        self.worker.getTrashCanList { [weak self] response in
            self?.presenter?.presentFetchTrashCan(response: response)
        }
    }
    func addTrashCan(request: Plogging.AddTrashCan.Request) {
        let response = Plogging.AddTrashCan.Response(latitude: request.latitude, longitude: request.longitude)
        self.presenter?.presentAddTrashCan(response: response)
    }
    
    func removeTrashCan(request: Plogging.RemoveTrashCan.Request) {
        UPLoader.shared.show()
        self.worker.deleteTrashCan(request: request) { [weak self] response in
            self?.presenter?.presentRemoveTrashCan(response: response)
        }
    }
    
    func addConfirmTrashCan(request: Plogging.AddConfirmTrashCan.Request) {
        UPLoader.shared.show()
        self.worker.addTrashCan(request: request) { [weak self] response in
            self?.presenter?.presentAddConfirmTrashCan(response: response)
        }
        
    }
}

extension PloggingInteractor: PloggingWorkerDelegate {
    
    func updateRoute(distance: Measurement<UnitLength>, location: Location) {
        let response = Plogging.UpdatePloggingLocation.Response(
            distance: distance,
            location: location
        )
        
        self.presenter?.presentUpdatePloggingLocation(response: response)
    }
}
