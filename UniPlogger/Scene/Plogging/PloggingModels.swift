//
//  PloggingModels.swift
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
import MapKit
enum Plogging {
    // MARK: Use cases
    
    enum UseCase {
        case FetchTrashCan
        case AddConfirmTrashCan(AddConfirmTrashCan.Request)
        case RemoveTrashCan(RemoveTrashCan.Request)
    }
    
    enum State {
        case stop
        case doing
    }
    
    enum UpdatePloggingLocation{
        struct Response {
            var distance: Measurement<UnitLength>
            var location: Location
        }
        
        struct ViewModel {
            var distance: String
            var region: MKCoordinateRegion
            var polyLine: MultiColorPolyline
        }
    }
    
    enum StopPlogging{
        struct Request{
            var seconds: Int
            var minutes: Int
        }
    }
    
    enum LocationAuth{
      struct Response {
        var status: CLAuthorizationStatus
      }
    }
    
    enum AddTrashCan{
        struct Request {
            var latitude: Double
            var longitude: Double
        }
        struct Response {
            var latitude: Double
            var longitude: Double
        }
        
        struct ViewModel {
            var address: String
        }
    }
    
    enum AddConfirmTrashCan{
        struct Request {
            var latitude: Double
            var longitude: Double
            var address: String
        }
        
        struct Response {
            var request: Request
            var response: TrashCan?
            var error: UniPloggerError?
        }
        
        struct ViewModel {
            var trashcan: TrashCan
        }
    }
    
    enum FetchTrashCan{
        struct Response {
            var list: [TrashCan]?
            var error: UniPloggerError?
        }
        
        struct ViewModel {
            var list: [TrashCan]
        }
    }
    
    enum RemoveTrashCan{
        struct Request{
            var id: Int64
            var latitude: Double
            var longitude: Double
        }
        
        struct Response {
            var request: Request
            var trashcan: TrashCan?
            var error: UniPloggerError?
        }
        
        struct ViewModel {
            var trashcan: TrashCan
        }
    }
    
    
}
