//
//  BaseTarget.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/12.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import Moya

protocol BaseTarget: TargetType {
    var parameters: [String: Any] { get }
}

extension BaseTarget {
    var baseURL: URL {
        guard let url = URL(string: SessionManager.environment.rawValue) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var headers: [String : String]? {
        var headers = [
            "Content-type": "application/json",
        ]
        if let token = AuthManager.shared.userToken{
            headers["Authorization"] = "JWT \(token)"
        }
        return headers

    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        case .put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}
