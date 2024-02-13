//
//  BaseResponse.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/12.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    // MARK: Properties
    enum Status: String, Codable {
        case success
        case fail
    }
    var status: Status
    var errorMessage: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorMessage
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseResponse.CodingKeys.self)
        status = try container.decode(Status.self, forKey: .status)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
    
}
