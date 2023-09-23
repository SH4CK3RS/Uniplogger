//
//  LoginService.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

protocol LoginServiceable {
    func login(model: LoginModel, completion: @escaping () -> Void)
}
    
struct LoginService: LoginServiceable {
    func login(model: LoginModel, completion: @escaping () -> Void) {
        AuthAPI.shared.login(email: model.account,
                             password: model.password) { (response) in
            switch response {
            case .success(let value):
                if value.success, let loginResponse = value.data {
//                    let response = Login.Login.Response(request:request, response: loginResponse)
//                    completion(response)
                    completion()
                } else {
//                    let response = Login.Login.Response(request:request, error: .server(value.message))
//                    completion(response)
                    completion()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
        
//        guard let loginResponse = response.response,
//              response.error == nil else {
//            viewController?.displayError(error: response.error!, useCase: .Login(response.request))
//            return
//        }
//        AuthManager.shared.userToken = loginResponse.token
//        AuthManager.shared.user = loginResponse.user
    }
}


