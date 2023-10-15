//
//  RegistrationService.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import RxSwift

protocol RegistrationServiceable {
    func registration(model: RegistrationModel) -> Single<LoginResponse>
}

struct RegistrationService: RegistrationServiceable {
    func registration(model: RegistrationModel) -> Single<LoginResponse> {
        AuthAPI.shared.registration(data: model)
    }
}
