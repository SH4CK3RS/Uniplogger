//
//  Feed.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

struct Feed: Codable {
    typealias TimeSet = (minutes: Int, seconds: Int)
    
    let id: Int
    let title: String
    let distance: Double
    let time: Int
    let imageUrl: String
    let user: User
    
    var timeSet: TimeSet {
        (time / 60, time % 60)
    }
}
