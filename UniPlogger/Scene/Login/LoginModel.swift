//
//  LoginModel.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

struct LoginModel {
    var account: String = ""
    var password: String = ""
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: account)
    }
    
    var isValidPassword: Bool {
        return password.count >= 8 && password.count <= 20
    }
    
    var isLoginButtonEnabled: Bool {
        isValidEmail && isValidPassword
    }
}
