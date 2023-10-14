//
//  PloggingData.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

struct PloggingData {
    typealias TimeSet = (minutes: Int, seconds: Int)
    
    var distance: Double = 0.0
    var time: Int = 0
    var items: [PloggingItemType] = []
    var image: UIImage?
    var endDate: Date?
    var title: String {
        guard let endDate else { return "" }
        return dateFormatter.string(from: endDate)
    }
    
    var timeSet: TimeSet {
        (time / 60, time % 60)
    }
    
    
    // helper
    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyyMMddhhmmss"
        $0.locale = Locale.init(identifier: "Ko_kr")
    }
}
