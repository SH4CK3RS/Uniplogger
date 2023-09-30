//
//  PloggingMainModel.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import CoreLocation

enum PloggingState {
    case stop
    case doing
}

struct PloggingMainModel {
    var distance = Measurement(value: 0, unit: UnitLength.kilometers)
    var locationList: [CLLocation] = []
    var ploggingState: PloggingState = .doing
    var minutes = 0
    var seconds = 0
    var timer: Timer?
    
    var currentLocation: CLLocation? {
        locationList.last
    }
    
    mutating func start() {
        distance = Measurement(value: 0, unit: UnitLength.meters)
        minutes = 0
        seconds = 0
        ploggingState = .doing
    }
}
