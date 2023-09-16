//
//  ManagedTrashCan+CoreDataProperties.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/02.
//  Copyright © 2020 손병근. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedTrashCan {

    @nonobjc static func fetchRequest() -> NSFetchRequest<ManagedTrashCan> {
        return NSFetchRequest<ManagedTrashCan>(entityName: "ManagedTrashCan")
    }
    @NSManaged var id: Int64
    @NSManaged var isRemoved: Bool
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var address: String
}
