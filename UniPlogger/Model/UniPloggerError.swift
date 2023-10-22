//
//  UniPloggerError.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

enum UniPloggerError: Error {
    enum NetworkError {
        case requestBuildError(String)
        case responseError(String)
        case alamofireError(Error)
    }
    
    case networkError(NetworkError)
    case permissionDenied(String)
    case fileSaveError(String)
    case other(String)
}

struct ErrorMessage {
    static let decodeError: String = "데이터를 받아오는 데 실패했습니다."
}
