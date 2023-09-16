//
//  ProceedingQuest+CoreDataProperties.swift
//  UniPlogger
//
//  Created by woong on 2020/12/05.
//  Copyright © 2020 손병근. All rights reserved.
//
//

import Foundation
import CoreData


extension ProceedingQuest {

    @nonobjc static func fetchRequest() -> NSFetchRequest<ProceedingQuest> {
        return NSFetchRequest<ProceedingQuest>(entityName: "ProceedingQuest")
    }
    
    @NSManaged var email: String
    @NSManaged var questId: Int16
    @NSManaged var time: Int64
    @NSManaged var distance: Double
    @NSManaged var finishDates: [Date]?
    @NSManaged var completeCount: Int16
    @NSManaged var pickedUpTrashs: [String: Int]?
    @NSManaged var finishCount: Int16
}
