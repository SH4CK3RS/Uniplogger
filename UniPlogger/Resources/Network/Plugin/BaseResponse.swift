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
    var success: Bool = false
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BaseResponse.CodingKeys.self)
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
    
}
