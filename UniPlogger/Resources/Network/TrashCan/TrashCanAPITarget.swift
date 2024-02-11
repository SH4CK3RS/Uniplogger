//
//  TrashCanAPITarget.swift
//  UniPlogger
//
//  Created by 손병근 on 2/10/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Foundation
import Moya

enum TrashCanAPITarget {
    case getTrashCans
    case addTrashCan(requestDTO: TrashCanRequestDTO)
}

extension TrashCanAPITarget: BaseTarget {
    var path: String {
        switch self {
        case .getTrashCans:
            return "trashCan"
        case .addTrashCan:
            return "trashCan"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTrashCans:
            return .get
        case .addTrashCan:
            return .post
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getTrashCans:
            return [:]
        case let .addTrashCan(requestDTO):
            return [
                "latitude": requestDTO.latitude,
                "longitude": requestDTO.longitude
            ]
        }
    }
    
    var task: Task {
        switch self {
        case .getTrashCans:
            return .requestPlain
        case .addTrashCan:
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var sampleData: Data {
      switch self {
      default:
        return Data()
      }
    }
    
}
