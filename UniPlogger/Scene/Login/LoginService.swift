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
    func login(model: LoginModel, completion: @escaping (Result<LoginResponse, UniPloggerError>) -> Void)
}

struct LoginService: LoginServiceable {
    func login(model: LoginModel, completion: @escaping (Result<LoginResponse, UniPloggerError>) -> Void) {
        AuthAPI.shared.login(email: model.account,
                             password: model.password) {
            switch $0 {
            case let .success(response):
                if response.success, let loginResponse = response.data {
                    completion(.success(loginResponse))
                } else {
                    completion(.failure(.networkError(.responseError(response.message ?? ""))))
                }
            case let .failure(error):
                completion(.failure(UniPloggerError.networkError(.responseError(error.localizedDescription))))
            }
        }
    }
}


