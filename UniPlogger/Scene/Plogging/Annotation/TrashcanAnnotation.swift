//
//  TrashAnnotation.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/10/18.
//  Copyright © 2020 손병근. All rights reserved.
//

import MapKit

class TrashcanAnnotation: NSObject, MKAnnotation{
    var id: Int64
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(
        id: Int64,
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String
    ) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}

class TempTrashAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
