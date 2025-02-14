//
//  TrashCan.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/10/31.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import CoreData

struct TrashCan: Codable {
    ///id
    var id: Int64
    ///위도
    var latitude: Double
    ///경도
    var longitude: Double
    ///삭제 되었는지에 대한 플래그
    var state: TrashCanState
    ///CoreData에서 구분용으로 사용하기 위한 구분자
    var address: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case state
        case address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TrashCan.CodingKeys.self)
        id = try container.decodeIfPresent(Int64.self, forKey: .id) ?? -1
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        state = try container.decodeIfPresent(TrashCanState.self, forKey: .state) ?? TrashCanState.disalbed
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
    }
}

enum TrashCanState: String, Codable {
    case enabled = "C"
    case disalbed = "NC"
}
