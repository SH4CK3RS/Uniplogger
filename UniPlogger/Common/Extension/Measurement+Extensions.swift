//
//  Measurement+Extensions.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

extension Measurement where UnitType == UnitLength {
    var formattedString: String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter.string(from: self)
    }
}
