//
//  PloggingAPITarget.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/12.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import Moya
import Alamofire

enum PloggingAPITarget{
    //쓰레기통 CRUD
    case createTrash(latitude: Double, longitude: Double, address: String)
    case fetchTrashList
    case uploadRecord(distance: Double, time: Int, image: UIImage)
    case deleteTrashCan(id: Int64)
}

extension PloggingAPITarget: BaseTarget {
    var path: String{
        switch self{
        case .createTrash:
            return "trashcans/"
        case .fetchTrashList:
            return "trashcans/"
        case .uploadRecord:
            return "plogging"
        case let .deleteTrashCan(id):
            return "trashcans/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .createTrash:
            return .post
        case .fetchTrashList:
            return .get
        case .uploadRecord:
            return .post
        case .deleteTrashCan:
            return .delete
        }
    }
    
    var parameters: [String : Any]{
        switch self{
        case let .createTrash(latitude, longitude, address):
            return [
              "latitude": latitude,
              "longitude": longitude,
              "address": address,
              "state": "C"
            ]
        case .fetchTrashList:
            return [:]
        case .uploadRecord:
            return [:]
        case .deleteTrashCan:
            return [:]
        }
    }
    
    var task: Task {
        switch self{
        case .createTrash:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .fetchTrashList:
            return .requestPlain
        case let .uploadRecord(distance, time, image):
            let compImg = image.jpegData(compressionQuality: 1.0)!
            let distanceData = MultipartFormData(provider: .data("\(distance)".data(using: .utf8)!), name: "distance")
            let timeData = MultipartFormData(provider: .data("\(time)".data(using: .utf8)!), name: "time")
            let imageData = MultipartFormData(provider: .data(compImg), name: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([distanceData, timeData, imageData])
                
        case .deleteTrashCan:
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        
    }
    
    var sampleData: Data {
      switch self {
      case .uploadRecord:
          if let url = Bundle.main.url(forResource: "UploadRecordResponse", withExtension: "json"),
             let data = try? Data(contentsOf: url) {
              return data
          }
          return Data()
      default:
        return Data()
      }
    }
    
}
