//
//  FindPasswordWorker.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/11.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class FindPasswordWorker {
    func validateAccount(text: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func findPassword(request: FindPassword.FindPassword.Request, completion: @escaping (FindPassword.FindPassword.Response) -> Void) {
        AuthAPI.shared.findPassword(email: request.email) { (response) in
            switch response {
            case let .success(value):
                if value.success, let data = value.data {
                    let response = FindPassword.FindPassword.Response(request: request, data: data)
                    completion(response)
                } else {
                    let response = FindPassword.FindPassword.Response(request: request, error: .networkError(.responseError(value.message ?? "")))
                    completion(response)
                }
            case let .failure(error):
                let response = FindPassword.FindPassword.Response(request: request, error: UniPloggerError.networkError(.responseError(error.localizedDescription)))
                completion(response)
            }
        }
    }
}
