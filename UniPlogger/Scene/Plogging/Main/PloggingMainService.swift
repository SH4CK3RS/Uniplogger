//
//  PloggingMainService.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/27.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import RxSwift

protocol PloggingMainServiceable {
    func getTrashCans() -> Single<[TrashCan]>
    func addTrashCan(latitude: Double, longitude: Double) -> Single<TrashCan>
}

struct PloggingMainService: PloggingMainServiceable {
    func getTrashCans() -> Single<[TrashCan]> {
        TrashCanAPI.shared.getTrashCans()
    }
    
    func addTrashCan(latitude: Double, longitude: Double) -> Single<TrashCan> {
        let requestDTO = TrashCanRequestDTO(latitude: latitude, longitude: longitude)
        return TrashCanAPI.shared.addTrashCan(requestDTO: requestDTO)
    }
}
