//
//  Contacts+Extensions.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/06.
//  Copyright © 2020 손병근. All rights reserved.
//

import CoreLocation

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
    func toAddress(completion: @escaping (String) -> Void) {
        self.geocode { placemark, error in
            guard error == nil,
            let placemark = placemark?.first else {
                completion("주소를 찾을 수 없습니다.")
                return
            }
            let str = [
                placemark.country,
                placemark.administrativeArea,
                placemark.locality,
                placemark.name,
                placemark.postalCode
            ]
                .compactMap { $0 }
                .joined(separator: " ")
            completion(str)
        }
    }
}
