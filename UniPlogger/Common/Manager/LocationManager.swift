//
//  LocationManager.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/27.
//  Copyright © 2023 손병근. All rights reserved.
//

import CoreLocation
import UIKit

enum LocationManagerAction {
    case locationAuthDenied
    case locationAuthorized
    case routeUpdated(distance: Measurement<UnitLength>, location: Location)
}

protocol LocationManagerListener: AnyObject {
    func action(_ action: LocationManagerAction)
}

protocol LocationManagable {
    func requestPermission()
    func updateLocation()
}

struct Location {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
}

final class LocationManager: NSObject, LocationManagable {
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Internal
    weak var listener: LocationManagerListener?
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Private
    private let locationManager = CLLocationManager()
    private var locationList: [CLLocation] = []
    private var distance = Measurement(value: 0, unit: UnitLength.kilometers)
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            listener?.action(.locationAuthDenied)
        case .notDetermined, .restricted:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            listener?.action(.locationAuthorized)
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let newLocation = locations.last {
                UserDefaults.standard.set(newLocation.coordinate.asDictionary, forDefines: .location)
                let howRecent = newLocation.timestamp.timeIntervalSinceNow
                
                guard abs(howRecent) < 10 else { return }
                if let lastLocation = self.locationList.last {
                    let delta = newLocation.distance(from: lastLocation)
                    distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                    let location = Location(
                        latitude: newLocation.coordinate.latitude,
                        longitude: newLocation.coordinate.longitude,
                        timestamp: newLocation.timestamp)
                    
                    listener?.action(.routeUpdated(distance: distance, location: location))
                }
                locationList.append(newLocation)
            }
        }
}
