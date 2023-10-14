//
//  LoginService.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginServiceable {
    func login(model: LoginModel) -> Single<LoginResponse>
}

struct LoginService: LoginServiceable {
    func login(model: LoginModel) -> Single<LoginResponse> {
        AuthAPI.shared.login(email: model.account, password: model.password)
    }
}


