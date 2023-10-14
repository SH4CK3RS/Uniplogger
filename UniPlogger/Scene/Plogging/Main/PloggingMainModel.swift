//
//  PloggingMainModel.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import MapKit

enum PloggingState {
    case stop
    case doing
}

// UID: -1
// title - dateString
// distance: Double
// time: Int = minutes * 60 + seconds
// image: UIImage

struct PloggingMainModel {
    var distance = Measurement(value: 0, unit: UnitLength.kilometers)
    var locationList: [CLLocation] = []
    var ploggingState: PloggingState = .stop
    var minutes = 0
    var seconds = 0
    var timer: Timer?
    var speeds: [Double] = []
    var minSpeed = Double.greatestFiniteMagnitude
    var maxSpeed = 0.0
    
    var midSpeed: Double {
        return speeds.reduce(0, +) / Double(speeds.count)
    }
    
    var currentLocation: CLLocation? {
        locationList.last
    }
    
    var mapRegion: MKCoordinateRegion? {
        guard !locationList.isEmpty else { return nil }
        
        let latitudes = locationList.map { $0.coordinate.latitude }
        let longitudes = locationList.map { $0.coordinate.longitude }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // MARK: - Record
    var time: Int {
        return minutes * 60 + seconds
    }
    
    
    mutating func start() {
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList = []
        speeds = []
        minutes = 0
        seconds = 0
        ploggingState = .doing
    }
}
