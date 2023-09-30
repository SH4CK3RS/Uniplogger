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
    case locationUpdated(CLLocation)
}

protocol LocationManagerListener: AnyObject {
    func action(_ action: LocationManagerAction)
}

protocol LocationManagable {
    var listener: LocationManagerListener? { get set }
    var isAuthorized: Bool { get }
    func requestPermission()
    func updateLocation()
    func stopUpdateLocation()
}

struct Location {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

final class LocationManager: NSObject, LocationManagable {
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 5
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // MARK: - Internal
    weak var listener: LocationManagerListener?
    var isAuthorized: Bool {
        locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
    func requestPermission() {
        guard !isAuthorized else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Private
    private let locationManager = CLLocationManager()
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
        guard let newLocation = locations.last,
              abs(newLocation.timestamp.timeIntervalSinceNow) < 10
        else { return }
        listener?.action(.locationUpdated(newLocation))
    }
}
