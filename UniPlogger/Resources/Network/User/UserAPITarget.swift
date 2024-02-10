//
//  UserAPITarget.swift
//  UniPlogger
//
//  Created by 손병근 on 2/10/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Foundation
import Moya

enum UserAPITarget {
    case getUser(uid: Int)
}

extension UserAPITarget: BaseTarget {
    var path: String {
        switch self {
        case let .getUser(uid):
            return "user/\(uid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getUser:
            return [:]
        }
    }
    
    var task: Task {
        switch self {
        case .getUser:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
      switch self {
      case .getUser:
          if let url = Bundle.main.url(forResource: "AutoLoginResponse", withExtension: "json"),
             let data = try? Data(contentsOf: url) {
              return data
          }
          return Data()
      default:
        return Data()
      }
    }
    
}
