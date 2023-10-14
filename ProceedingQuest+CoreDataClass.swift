//
//  ProceedingQuest+CoreDataClass.swift
//  UniPlogger
//
//  Created by woong on 2020/12/05.
//  Copyright © 2020 손병근. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ProceedingQuest)
class ProceedingQuest: NSManagedObject {
    
    func append(_ ploggingData: PloggingData) {
        time += Int64(ploggingData.time)
        distance += floor((ploggingData.distance) * 100)
        finishDates?.append(Date())
        finishCount += 1
        ploggingData.items.forEach { item in
            if pickedUpTrashs == nil {
                pickedUpTrashs = [:]
            }
            pickedUpTrashs?[item.rawValue, default: 0] += 1
        }
    }
}
