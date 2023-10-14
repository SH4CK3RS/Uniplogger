//
//  PloggingRootService.swift
//  UniPlogger
//
//  Created by 손병근 on 10/9/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import RxSwift

protocol PloggingRootServiceable {
    func uploadPloggingRecord(data: PloggingData) -> Single<Feed>
}

struct PloggingRootService: PloggingRootServiceable {
    func uploadPloggingRecord(data: PloggingData) -> Single<Feed> {
        PloggingAPI.shared.uploadRecord(data: data)
    }
}
