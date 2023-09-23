//
//  RegistrationModel.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

struct RegistraionModel {
    var email: String = ""
    var password: String = ""
    var passwordConfirm: String = ""
    var nickname: String = ""
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    var isValidPassword: Bool {
        guard password == passwordConfirm else { return false }
        return password.count >= 8 && password.count <= 20
    }
    
    var isValidNickname: Bool {
        nickname.count >= 1 && nickname.count <= 6
    }
    
    var isRegistrationButtonEnabled: Bool {
        isValidEmail && isValidPassword && isValidNickname
    }
}
