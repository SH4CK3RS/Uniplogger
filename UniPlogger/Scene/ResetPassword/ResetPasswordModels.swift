//
//  ResetPasswordModels.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/13.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ResetPassword {
    // MARK: Use cases
    
    enum UseCase {
        case ResetPassword(ResetPassword.Request)
    }
    
    enum ResetPassword{
        struct Request{
            var password1: String
            var password2: String
        }
        
        struct Response {
            var request: Request
            var response: ResetPasswordResponse?
            var error: UniPloggerError?
        }
        
        struct ViewModel {
            var detail: String?
        }
    }
    
    enum ValidatePassword{
      struct Request{
        var password: String
      }
      struct Response {
        var isValid: Bool
      }
    }
    
    enum ValidatePasswordConfirm{
      struct Request{
        var password: String
        var passwordConfirm: String
      }
      struct Response {
        var isValid: Bool
      }
    }
    
    struct ValidationViewModel{
      var isValid: Bool
    }
}
