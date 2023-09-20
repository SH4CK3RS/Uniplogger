//
//  RegistrationService.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

protocol RegistrationServiceable {
    func registration(model: RegistraionModel, completion: @escaping () -> Void)
}

struct RegistrationService: RegistrationServiceable {
    func registration(model: RegistraionModel, completion: @escaping () -> Void) {
        AuthAPI.shared.registration(
            email: model.email,
            password1: model.password,
            password2: model.passwordConfirm,
            nickname: model.nickname) { (response) in
            switch response {
            case let .success(value):
                if value.success, let loginResponse = value.data{
                    AuthManager.shared.userToken = loginResponse.token
                    AuthManager.shared.user = loginResponse.user
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        AuthAPI.shared.initQuest()
                    }
//                    let response = Registration.Registration.Response(request: request, response: loginResponse)
//                    completion(response)
                    completion()
                } else {
//                    let response = Registration.Registration.Response(request: request, error: .server(value.message))
//                    completion(response)
                    completion()
                }
            case let .failure(error):
//                let response = Registration.Registration.Response(request: request, error: .error(error))
//                completion(response)
                completion()
            }
        }
    }
}
