//
//  ErrorResponse.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    static let `default` = ErrorResponse(reason: "알 수 없는 오류")
    let reason: String
}
