//
//  PloggingRouter.swift
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

@objc protocol PloggingRoutingLogic {
    func routeToStartCounting()
    func routeToPloggingRecord()
}

protocol PloggingDataPassing {
    var dataStore: PloggingDataStore? { get }
}

final class PloggingRouter: NSObject, PloggingRoutingLogic, PloggingDataPassing {
    weak var viewController: PloggingViewController?
    var dataStore: PloggingDataStore?
    
    
    //MARK: - Routing Logic
    func routeToStartCounting() {
        let destinationVC = StartCountingViewController()
        navigateToStartCounting(source: viewController!, destination: destinationVC)
    }
    func routeToPloggingRecord() {
//        let destinationVC = PloggingRecordViewController()
//        var destinationDs = destinationVC.router!.dataStore!
//        passDataToPloggingRecord(source: dataStore!, destination: &destinationDs)
//        navigateToPloggingRecord(source: viewController!, destination: destinationVC)
    }
    
    
    //MARK: - Navigation Logic
    func navigateToStartCounting(source: PloggingViewController, destination: StartCountingViewController) {
        destination.modalTransitionStyle = .crossDissolve
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true)
    }
    
    func navigateToPloggingRecord(source: PloggingViewController, destination: PloggingRecordViewController) {
        let nvc = UINavigationController(rootViewController: destination)
        nvc.navigationBar.isHidden = true
        nvc.modalTransitionStyle = .crossDissolve
        nvc.modalPresentationStyle = .fullScreen
        source.present(nvc, animated: true)
    }
    
    //MARK: - Data Passing Logic
//    func passDataToPloggingRecord(source: PloggingDataStore, destination: inout PloggingRecordDataStore) {
//        destination.ploggingData = source.ploggingData
//    }
}
