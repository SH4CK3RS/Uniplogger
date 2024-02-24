//
//  UniPloggerError.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

enum UniPloggerError: LocalizedError {
    enum NetworkError: LocalizedError {
        case requestBuildError(String)
        case responseError(String)
        case alamofireError(Error)
        
        var errorDescription: String? {
            switch self {
            case .requestBuildError(let reason), .responseError(let reason):
                return reason
            case .alamofireError(let underlyingError):
                return underlyingError.localizedDescription
            }
        }
    }
    
    case networkError(NetworkError)
    case permissionDenied(reason: String)
    case fileSaveError(reason: String)
    case other(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.errorDescription
        case .permissionDenied(let reason), .fileSaveError(let reason), .other(let reason):
            return reason
        }
    }
}

struct ErrorMessage {
    static let decodeError: String = "데이터를 받아오는 데 실패했습니다."
}
